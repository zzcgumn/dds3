#!/usr/bin/env python3
"""
Quick guardrail scan for mutable globals/statics in C/C++ sources.

- Flags function-local `static` that are not `constexpr` or `const`.
- Flags non-const globals at file scope.
- Skips generated and external dirs (bazel-*, external/).

Usage:
  python3 copilot/scripts/check_mutable_statics.py [root=.] [--fail]

Exit codes:
  0: no suspicious patterns found (or only warnings without --fail)
  1: suspicious patterns found and --fail is set
"""
import os
import re
import sys
from typing import List, Tuple

ROOT = sys.argv[1] if len(sys.argv) > 1 and not sys.argv[1].startswith('--') else '.'
FAIL = '--fail' in sys.argv

SRC_EXT = ('.c', '.cc', '.cpp', '.cxx', '.h', '.hpp')
SKIP_DIRS = {'bazel-bin', 'bazel-out', 'bazel-testlogs', 'bazel-dds', 'external', '.git'}

# Regexes (quick heuristics, not a full parser)
RE_STATIC_MUT = re.compile(r'\bstatic\b(?!\s+(?:const|constexpr))')
RE_GLOBAL_VAR = re.compile(r'^[\t ]*(?!template)(?!class)(?!struct)(?!enum)(?!using)(?!namespace)(?!#)(?!friend)(?!typedef)(?!inline)(?!constexpr)(?!const)\w[\w:<>]*\s+\w+\s*(?:=|;)', re.MULTILINE)


def should_skip(path: str) -> bool:
    parts = set(path.split(os.sep))
    return bool(parts & SKIP_DIRS)


def scan_file(path: str) -> List[Tuple[int, str, str]]:
    issues = []
    try:
        with open(path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except Exception:
        return issues

    # Flag function-local static (approx) and file-scope globals
    for m in RE_STATIC_MUT.finditer(content):
        line = content.count('\n', 0, m.start()) + 1
        issues.append((line, 'static-nonconst', 'mutable static (not const/constexpr)'))

    # Roughly detect file-scope globals: lines starting with a type + identifier
    # Heuristic to reduce false positives: ignore lines with '(' before ';' (likely functions)
    for m in RE_GLOBAL_VAR.finditer(content):
        snippet = content[m.start(): content.find('\n', m.start())]
        if '(' in snippet and (')' in snippet or ';' in snippet):
            continue
        line = content.count('\n', 0, m.start()) + 1
        # Ignore lines explicitly marked as const/constexpr
        if re.search(r'\b(const|constexpr)\b', snippet):
            continue
        issues.append((line, 'global-nonconst', 'possible non-const global variable'))

    return issues


def main() -> int:
    findings: List[Tuple[str, int, str, str]] = []

    for root, dirs, files in os.walk(ROOT):
        if should_skip(root):
            dirs[:] = []
            continue
        for fn in files:
            if fn.endswith(SRC_EXT):
                path = os.path.join(root, fn)
                rel = os.path.relpath(path, ROOT)
                for line, kind, msg in scan_file(path):
                    findings.append((rel, line, kind, msg))

    if findings:
        print('Mutable state guardrail findings:')
        for rel, line, kind, msg in findings:
            print(f'- {rel}:{line}: [{kind}] {msg}')
        if FAIL:
            return 1
    else:
        print('No suspicious mutable statics/globals found by heuristic scan.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
