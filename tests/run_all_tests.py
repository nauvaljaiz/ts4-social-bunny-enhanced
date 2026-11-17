# -*- coding: utf-8 -*-
"""Test runner for Social Bunny Verified (executes on Python 3.7)."""

import os
import sys
import unittest

if __name__ == "__main__":
    tests_dir = os.path.dirname(os.path.abspath(__file__))
    suite = unittest.defaultTestLoader.discover(tests_dir, pattern="test_*.py")
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)
    sys.exit(0 if result.wasSuccessful() else 1)
