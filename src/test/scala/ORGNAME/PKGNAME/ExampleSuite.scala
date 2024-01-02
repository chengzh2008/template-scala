package ORGNAME.PKGNAME

import ORGNAME.lib.Add.add

final class ExampleSuite extends TestSuite:
  test("hello world"):
    forAll: (int: Int, string: String) =>
      expectEquals(int, int)
      expectEquals(string, string)

  test("lib add"):
    expectEquals(add(3, 4), 7)
