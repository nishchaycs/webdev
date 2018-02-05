defmodule Calc do
	import Stack
	import Pfeval
  @moduledoc """
  Documentation for Calc.
  """

  def main() do
    case IO.gets("> ") do
      :eof ->
        IO.puts "All done"
      {:error, reason} ->
        IO.puts "Error: #{reason}"
      line ->
        IO.puts(Calc.eval(line |> String.trim))
        main()
    end
  end

  def eval(expr) do
  	expr
  	|> String.replace("(", "( ")
    |> String.replace(")", " )")
  	|> String.split(" ")
  	|> Enum.filter(fn x -> x != "" && x != " "end)
  	|> calculate
  end

  defp calculate(tokens) do
  	IO.inspect(tokens)
  	s = Stack.new
  	pfe = Pfeval.new
  	pfe = Enum.reduce(tokens, pfe, fn(x, pfe) -> inToPost(x, pfe) end)
  	pf = pfe.postfix
  	st = pfe.stack
  	IO.inspect(pf)
  	pf = pf ++ allTokens(st)
  	IO.inspect(pf)
  	s = Enum.reduce(pf, s, fn(x, s) -> postfixEval(x, s) end)
  	elem(Stack.pop(s),0)
  end

  defp inToPost(token, pfe) do  
  	pf = pfe.postfix
  	s = pfe.stack	
  	if !isOperator(token) and token !== "(" and token !== ")" do
  		pf = List.insert_at(pf, -1, token)
  	else
  		if isOperator(token) do  			
  			if Stack.top(s) !== nil do
	  			pfe = allPreTokens(token, pfe)
	  			pf = pfe.postfix
  				s = pfe.stack	
  			end
  			s = Stack.push(token, s)    			 			
  		end  		
  		if token === "(" do
  			s = Stack.push(token, s)
  		end
  		if token === ")" do
  			if Stack.top(s) !== "(" do
  				pfe = allParTokens(token, pfe)
  				pf = pfe.postfix
  				s = pfe.stack
  			end
  			s = elem(Stack.pop(s), 1)
  		end
  	end
  	pfe = %{pfe | postfix: pf}
  	pfe = %{pfe | stack: s}
  	pfe
  end  

  defp allParTokens(token, pfe) do
  	allts = pfe.postfix
  	s = pfe.stack
  	if Stack.top(s) !== "(" do
  		if Stack.depth(s) !== 1 do
			allts = allts ++ [Stack.top(s)] 
  			s = elem(Stack.pop(s), 1)
			pfe = %{pfe | postfix: allts}
  			pfe = %{pfe | stack: s}
  			pfe = allParTokens(token, pfe)
		else
			allts = allts ++ [Stack.top(s)] 
  			s = elem(Stack.pop(s), 1)
			pfe = %{pfe | postfix: allts}
  			pfe = %{pfe | stack: s}
		end
	end
  	pfe
  end

  defp allPreTokens(token, pfe) do
  	allts = pfe.postfix
  	s = pfe.stack
  	if precedence(token) <= precedence(Stack.top(s)) and Stack.top(s) !== "(" do
  		if Stack.depth(s) !== 1 do
  			allts = allts ++ [Stack.top(s)] 
  			s = elem(Stack.pop(s), 1)
			pfe = %{pfe | postfix: allts}
  			pfe = %{pfe | stack: s}
  			pfe = allPreTokens(token, pfe)
  		else
  			allts = allts ++ [Stack.top(s)] 
  			s = elem(Stack.pop(s), 1)
			pfe = %{pfe | postfix: allts}
  			pfe = %{pfe | stack: s}
  		end
	end
	pfe
  end

  defp allTokens(s) do
  	allts = []
  	if Stack.top(s) !== "(" do
  		if Stack.depth(s) !== 1 do
			allts = allts ++ [Stack.top(s)] 
			s = elem(Stack.pop(s), 1)
			allts = allts ++ allTokens(s)
		else
			allts = allts ++ [Stack.top(s)]
		end
	end
	allts
  end

  defp precedence(op) do
  	p = 0
  	if op === "-" or op === "+" do
  		p = 1
  	end
  	if op === "/" or op === "*" do
  		p = 2
  	end
	if op === "(" do
  		p = 3	  	
  	end  	
  	p
  end

  defp strToIntStack(str, stack) do
  	stack = Enum.reduce(str, stack, fn(x, stack) -> elem(Integer.parse(x),0) |> Stack.push(stack) end)
  	stack
  end

  defp postfixEval(pfstr, stack) do
  	if pfstr |> isOperator do
		a = elem(Stack.pop(stack),0)
		stack = elem(Stack.pop(stack),1)
		b = elem(Stack.pop(stack),0)
		stack = elem(Stack.pop(stack),1)
		c = operate(a, b, pfstr)
		stack = Stack.push(c, stack)
	else
		stack = Stack.push(elem(Integer.parse(pfstr), 0), stack)
	end  		
  end

  defp isOperator(token) do
  	token === "+" or token === "-" or token === "*" or token === "/"
  end

  defp operate(a, b, op) do
  	case op do
  		"+" -> a + b
  		"-" -> b - a
  		"*" -> a * b
  		"/" -> div(b,a)
  		_ -> a
  	end
  end

end
