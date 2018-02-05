defmodule Pfeval do
	import Stack
	defstruct postfix: [], stack: Stack.new

	def new, do: %Pfeval{}
end