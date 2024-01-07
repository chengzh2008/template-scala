package ORGNAME.PKGNAME

import ORGNAME.lib.Add.add
import ORGNAME.lib.*
import ORGNAME.lib.MyOption.MyOption
import ORGNAME.lib.Monad.MonadOps

final class ExampleSuite extends TestSuite:
  test("hello world"):
    forAll: (int: Int, string: String) =>
      expectEquals(int, int)
      expectEquals(string, string)

  test("lib add"):
    expectEquals(add(3, 4), 7)

  test("monad"):
    val option1: MyOption[Int] = summon[Monad[MyOption]].unit(42)
    val option2: MyOption[Int] = summon[Monad[MyOption]].unit(10)

    val result: MyOption[Int] =
      option1.flatMap(a => option2.map(b => a + b))

    expectEquals(result, MyOption.Some(52))
