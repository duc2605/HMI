"""Update Git-derived metadata; preserve the faculty report's manual assessment."""
from datetime import datetime, timezone, timedelta
from pathlib import Path
import os
import re
import subprocess

START = "<!-- AUTO-PROGRESS:START -->"
END = "<!-- AUTO-PROGRESS:END -->"
BOT_SUBJECT = "docs: tu dong cap nhat bao cao tien do"


def git(*args):
    return subprocess.check_output(["git", *args]).decode("utf-8", errors="replace").strip()


def cell(value):
    # Render commit messages as text, including pipes, markup and newlines.
    value = value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
    value = value.replace("|", "&#124;")
    for char in "\\`*_[]!":
        value = value.replace(char, "\\" + char)
    return " ".join(value.split())


def main():
    path = Path("README_TIEN_DO.md")
    report = path.read_text(encoding="utf-8")
    commits = []
    for sha in git("rev-list", "--max-count=150", "HEAD").splitlines():
        fields = git("show", "-s", "--format=%H%x00%aI%x00%an%x00%s%x00%b", sha).split("\x00", 4)
        full, date, author, subject, body = fields
        if author == "github-actions[bot]" and subject == BOT_SUBJECT:
            continue
        commits.append((full, date, subject, body))
        if len(commits) == 15:
            break
    if not commits:
        raise RuntimeError("Khong tim thay commit de lap bao cao")
    repository = os.environ.get("GITHUB_REPOSITORY", "duc2605/HMI")
    if not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", repository):
        raise ValueError("GITHUB_REPOSITORY khong hop le")
    base = "https://github.com/" + repository
    latest = commits[0]
    local_date = datetime.fromisoformat(latest[1]).astimezone(timezone(timedelta(hours=7)))
    lines = [START, "## Cập nhật tự động từ GitHub", "",
             "> Mục này phản ánh lịch sử Git. Đánh giá hoàn thành và kết quả chạy thử ở các phần bên dưới thuộc mốc đánh giá thủ công, cần được nhóm xác nhận lại khi có thay đổi.", "",
             "- **Thời điểm commit nguồn mới nhất:** " + local_date.strftime("%d/%m/%Y %H:%M") + " (UTC+7).",
             f"- **Phiên bản nguồn:** [`{latest[0][:7]}`]({base}/commit/{latest[0]}).",
             "- **Nội dung cập nhật:** " + cell(latest[2]) + ".", "",
             "### 15 thay đổi gần nhất của người phát triển", "",
             "Nội dung dưới đây lấy từ thông điệp commit do người thực hiện ghi, chưa phải kết quả nghiệm thu tự động.", "",
             "| Ngày (UTC+7) | Commit | Nội dung | Ghi chú/kết quả do người thực hiện ghi |",
             "|---|---|---|---|"]
    for sha, date, subject, body in commits:
        day = datetime.fromisoformat(date).astimezone(timezone(timedelta(hours=7))).strftime("%d/%m/%Y")
        lines.append(f"| {day} | [`{sha[:7]}`]({base}/commit/{sha}) | {cell(subject)} | {cell(body) or 'Chưa ghi thêm'} |")
    lines += ["", "Muốn bổ sung kết quả thử nghiệm vào mục này, ghi chúng trong phần mô tả commit. Cập nhật trực tiếp các phần đánh giá bên dưới khi đã xác nhận chức năng.", END]
    block = "\n".join(lines)
    if report.count(START) != report.count(END) or report.count(START) > 1:
        raise ValueError("Moc AUTO-PROGRESS bi thieu hoac trung")
    if START in report:
        begin, end = report.index(START), report.index(END) + len(END)
        if end < begin:
            raise ValueError("Thu tu moc AUTO-PROGRESS khong hop le")
        report = report[:begin] + block + report[end:]
    else:
        title, rest = report.split("\n", 1)
        report = title + "\n\n" + block + "\n" + rest
    path.write_text(report, encoding="utf-8", newline="\n")


if __name__ == "__main__":
    main()
