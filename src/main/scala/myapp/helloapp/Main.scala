package myapp.helloapp

import myapp.lib.Add.add

@main def Main(args: String*): Unit =
  println("─" * 100)

  println("hello world")

  println("─" * 100)

  println(add(3, 4))
