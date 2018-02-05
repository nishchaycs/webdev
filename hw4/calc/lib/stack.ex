defmodule Stack do
  defstruct elements: []

  def new, do: %Stack{}

  def push(element, stack) do
    %Stack{stack | elements: [element | stack.elements]}
  end

  def pop(%Stack{elements: []}), do: raise("Stack is empty!")
  def pop(%Stack{elements: [top | rest]}) do
    {top, %Stack{elements: rest}}
  end

  def top(%Stack{elements: []}) do 
    nil
  end
  def top(%Stack{elements: [top | rest]}) do
    top
  end

  def depth(%Stack{elements: elements}), do: length(elements)
end

# Attribution: https://codereview.stackexchange.com/questions/48733/how-does-this-naive-stack-implementation-look