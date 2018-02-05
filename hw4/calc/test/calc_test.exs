defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "test1" do
    assert Calc.eval("( 12 / 4 ) - 2 * 2") == -1
  end
  test "test2" do
    assert Calc.eval("3 * 4 - 4 * ( 2 + 1 )") == 0
  end
end
