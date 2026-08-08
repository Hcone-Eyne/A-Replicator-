"""Outbound email delivery.

In development (no ``FLOW_SMTP_HOST`` configured) emails are logged to the
console so flows can be tested end-to-end without a real mail server.
"""
import logging

from ..config import settings

logger = logging.getLogger("flow_app.mailer")


def send_email(to: str, subject: str, text: str = "", html: str = "") -> None:
    """Deliver an email to ``to``.

    Falls back to logging the message when SMTP is not configured.
    """
    if settings.smtp_host:
        _send_via_smtp(to, subject, text, html)
        return

    logger.info("[dev-email] To: %s | Subject: %s\n%s", to, subject, text or html)


def _send_via_smtp(to: str, subject: str, text: str, html: str) -> None:
    import smtplib
    from email.mime.multipart import MIMEMultipart
    from email.mime.text import MIMEText

    message = MIMEMultipart("alternative")
    message["Subject"] = subject
    message["From"] = settings.smtp_from
    message["To"] = to
    if text:
        message.attach(MIMEText(text, "plain"))
    if html:
        message.attach(MIMEText(html, "html"))

    with smtplib.SMTP(settings.smtp_host, settings.smtp_port) as server:
        server.starttls()
        if settings.smtp_user:
            server.login(settings.smtp_user, settings.smtp_password)
        server.sendmail(settings.smtp_from, [to], message.as_string())
