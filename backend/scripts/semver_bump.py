#!/usr/bin/env python3
"""Determine the next semantic version based on commit history.

The script reads the latest git tag matching ``vX.Y.Z`` (or ``X.Y.Z``) and then
analyses commit messages since that tag.  It loosely follows the Conventional
Commits guidelines: commits mentioning ``BREAKING CHANGE`` or using the ``!``
syntax trigger a major bump, ``feat`` commits trigger a minor bump, and all
other commits trigger a patch bump.  If no tag is found the base version is
``0.0.0`` and the script returns ``0.1.0`` to bootstrap the release process.
"""
from __future__ import annotations

import re
import subprocess
import sys
from dataclasses import dataclass
from typing import Iterable

SEMVER_PATTERN = re.compile(r"^v?(?P<major>\d+)\.(?P<minor>\d+)\.(?P<patch>\d+)$")


class GitError(RuntimeError):
    """Raised when a git command cannot be executed."""


@dataclass(frozen=True)
class Version:
    major: int
    minor: int
    patch: int
    tag: str | None = None

    @classmethod
    def from_tag(cls, tag: str) -> "Version":
        match = SEMVER_PATTERN.match(tag)
        if not match:
            raise ValueError(f"Tag '{tag}' is not a semantic version")
        return cls(
            int(match.group("major")),
            int(match.group("minor")),
            int(match.group("patch")),
            tag=tag,
        )

    def bump(self, level: str) -> "Version":
        if level == "major":
            return Version(self.major + 1, 0, 0)
        if level == "minor":
            return Version(self.major, self.minor + 1, 0)
        return Version(self.major, self.minor, self.patch + 1)

    def __str__(self) -> str:  # pragma: no cover - trivial string representation
        return f"{self.major}.{self.minor}.{self.patch}"


def run_git(*args: str) -> str:
    result = subprocess.run(
        ("git",) + args,
        check=False,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    if result.returncode != 0:
        raise GitError(result.stderr.strip() or "Git command failed")
    return result.stdout.strip()


def get_latest_semver_tag() -> Version | None:
    try:
        raw_tags = run_git("tag", "--list")
    except GitError:
        return None

    tags: list[Version] = []
    for tag in raw_tags.splitlines():
        tag = tag.strip()
        if not tag:
            continue
        match = SEMVER_PATTERN.match(tag)
        if match:
            tags.append(Version.from_tag(tag))

    if not tags:
        return None

    def sort_key(version: Version) -> tuple[int, int, int]:
        return version.major, version.minor, version.patch

    return max(tags, key=sort_key)


def get_commit_messages(since_tag: Version | None) -> Iterable[str]:
    try:
        if since_tag is None:
            log_output = run_git("log", "--pretty=%s%n%b")
        else:
            range_spec = f"{since_tag.tag or str(since_tag)}..HEAD"
            log_output = run_git("log", range_spec, "--pretty=%s%n%b")
    except GitError:
        return []

    if not log_output:
        return []

    commits: list[str] = []
    buffer: list[str] = []
    for line in log_output.splitlines():
        if line.strip() == "":
            if buffer:
                commits.append("\n".join(buffer).strip())
                buffer = []
            continue
        buffer.append(line)
    if buffer:
        commits.append("\n".join(buffer).strip())
    return commits


def determine_bump(commits: Iterable[str]) -> str:
    bump = "patch"
    for commit in commits:
        if not commit:
            continue
        subject, *body_lines = commit.splitlines()
        body = "\n".join(body_lines)
        if "BREAKING CHANGE" in body or re.search(r"!:", subject):
            return "major"
        if re.match(r"feat(\(|:|!|$)", subject):
            bump = "minor"
    return bump


def main() -> int:
    latest_tag = get_latest_semver_tag()
    commits = list(get_commit_messages(latest_tag))

    bump_level = determine_bump(commits)

    if latest_tag is None:
        if not commits:
            print("0.1.0")
            return 0
        if bump_level == "major":
            next_version = Version(1, 0, 0)
        else:
            # For both "minor" and "patch" bumps we start at 0.1.0 to
            # bootstrap the release history.
            next_version = Version(0, 1, 0)
    else:
        base = latest_tag
        next_version = base.bump(bump_level)
    print(next_version)
    return 0


if __name__ == "__main__":
    sys.exit(main())
