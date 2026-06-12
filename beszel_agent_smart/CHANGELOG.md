# Changelog

## 1.0.4

- Fix: explicitly set DOCKER_HOST so Beszel detects Docker containers

## 1.0.3

- Fix: remove UTF-8 BOM and enforce LF line endings on shell scripts via .gitattributes

## 1.0.2

- Fix: further run.sh corruption (RO_FLAG line with non-printable byte)

## 1.0.1

- Fix: correct run.sh corruption from initial import (TOKEN assignment, httpd path)

## 1.0.0

- Initial release based on upstream Beszel Agent (S.M.A.R.T.) v0.18.7
- Builds from official Beszel binary releases (henrygd/beszel)
- Upstream source: vineetchoudhary/home-assistant-beszel-agent
