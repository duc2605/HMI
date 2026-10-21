using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

internal static class Launcher
{
    [STAThread]
    private static void Main()
    {
        Application.EnableVisualStyles();
        string root = AppDomain.CurrentDomain.BaseDirectory;
        try
        {
            foreach (Process p in Process.GetProcessesByName("HmiRTm"))
            {
                bool running;
                using (p) { running = !p.HasExited; }
                if (running)
                    throw new Exception("Hay dong WinCC Runtime dang mo, roi bam ChayDuAn.exe lai.");
            }
            string data = Path.Combine(root, @"Runtime\pdata.fwc");
            string supervisor = Path.Combine(root, @"Tools\Start-HmiVideo.ps1");
            Require(data);
            Require(supervisor);
            foreach (string name in new string[] { "ffmpeg.exe", "mediamtx.exe", "mediamtx.yml" })
                Require(Path.Combine(root, "Tools", name));

            string engine = FindEngine();
            if (engine == null) return;

            // Use the Windows file association; no undocumented Factory I/O flags.
            bool factoryOpen = false;
            foreach (Process p in Process.GetProcesses())
            {
                using (p)
                {
                    try
                    {
                        if (p.ProcessName.IndexOf("factory", StringComparison.OrdinalIgnoreCase) >= 0
                            && p.MainWindowHandle != IntPtr.Zero) factoryOpen = true;
                    }
                    catch (InvalidOperationException) { }
                }
            }
            if (!factoryOpen)
            {
                string[] scenes = Directory.Exists(Path.Combine(root, "FactoryIO"))
                    ? Directory.GetFiles(Path.Combine(root, "FactoryIO"), "*.factoryio") : new string[0];
                if (scenes.Length == 1)
                {
                    try { Process.Start(new ProcessStartInfo(scenes[0]) { UseShellExecute = true }); }
                    catch (Exception)
                    {
                        MessageBox.Show("Hay mo Factory I/O va scene cua du an thu cong. Video se tu bat khi co cua so Factory I/O.", "Factory I/O");
                    }
                }
                else
                {
                    MessageBox.Show("Hay mo Factory I/O va scene cua du an. De tu mo, dat dung mot file .factoryio vao thu muc FactoryIO.", "Factory I/O");
                }
            }

            using (Process runtime = Process.Start(new ProcessStartInfo(engine,
                Quote(data) + " /ShowLayout /Simulation /Restart /L1033")
                { WorkingDirectory = Path.GetDirectoryName(data), UseShellExecute = false }))
            {
                if (runtime == null) throw new Exception("Khong khoi dong duoc WinCC Runtime.");
                string powershell = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.System),
                    @"WindowsPowerShell\v1.0\powershell.exe");
                using (Process worker = Process.Start(new ProcessStartInfo(powershell,
                    "-NoLogo -NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File "
                    + Quote(supervisor) + " -RuntimeId " + runtime.Id)
                    { WorkingDirectory = Path.Combine(root, "Tools"), UseShellExecute = false,
                      CreateNoWindow = true, WindowStyle = ProcessWindowStyle.Hidden }))
                {
                    if (worker == null) throw new Exception("Khong khoi dong duoc video. Xem Tools\\video-logs.");
                }
            }
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "HMI - Khoi dong", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }

    private static void Require(string path)
    {
        if (!File.Exists(path)) throw new FileNotFoundException("Thieu file:\n" + path + "\nHay chay TaoBoChay.cmd truoc.");
    }

    private static string Quote(string value) { return "\"" + value + "\""; }

    private static string FindEngine()
    {
        string configDir = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "HUST-HMI-Portable");
        string config = Path.Combine(configDir, "runtime-path.txt");
        if (File.Exists(config))
        {
            string saved = File.ReadAllText(config).Trim();
            if (File.Exists(saved)) return saved;
        }
        foreach (string programDir in new string[] { Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86), Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles) })
        {
            if (String.IsNullOrEmpty(programDir)) continue;
            string candidate = Path.Combine(programDir, @"Siemens\Automation\WinCC RT Advanced\HmiRTm.exe");
            if (File.Exists(candidate)) return candidate;
        }
        MessageBox.Show("Khong tim thay WinCC Runtime. Hay chon HmiRTm.exe cua WinCC Runtime Advanced tuong thich voi du an V20.", "Chon WinCC Runtime");
        using (OpenFileDialog dialog = new OpenFileDialog())
        {
            dialog.Filter = "WinCC Runtime (HmiRTm.exe)|HmiRTm.exe";
            dialog.Title = "Chon HmiRTm.exe";
            if (dialog.ShowDialog() != DialogResult.OK) return null;
            Directory.CreateDirectory(configDir);
            File.WriteAllText(config, dialog.FileName);
            return dialog.FileName;
        }
    }
}
