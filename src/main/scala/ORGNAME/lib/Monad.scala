package ORGNAME.lib

trait Monad[M[_]]:
  def unit[A](a: A): M[A]
  def flatMap[A, B](ma: M[A])(f: A => M[B]): M[B]

object Monad:
  // Define some common monad operations
  def map[A, B, M[_]](
    ma: M[A]
  )(
    f: A => B
  )(using
    Monad[M]
  ): M[B] =
    summon[Monad[M]].flatMap(ma)(a => summon[Monad[M]].unit(f(a)))

  // Define an implicit conversion for monadic operations
  implicit class MonadOps[A, M[_]](
    ma: M[A]
  )(using
    Monad[M]
  ):
    def flatMap[B](f: A => M[B]): M[B] = summon[Monad[M]].flatMap(ma)(f)
    def map[B](f: A => B): M[B] = Monad.map(ma)(f)

object MyOption:
  // Example: Implementing Option as a Monad
  enum MyOption[+A]:
    case Some(value: A)
    case None

  given Monad[MyOption] with
    def unit[A](a: A): MyOption[A] = MyOption.Some(a)
    def flatMap[A, B](ma: MyOption[A])(f: A => MyOption[B]): MyOption[B] =
      ma match
        case MyOption.Some(a) => f(a)
        case MyOption.None => MyOption.None
