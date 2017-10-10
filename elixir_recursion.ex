require IEx;

defmodule M do

  #runs through the range from first to last, getting all the square roots
  def find_roots(first, last) do
    root_prov_pid = spawn(fn() -> root_provider() end)
    number_generator(first, last, root_prov_pid)
  end

  #generates the numbers in the range and asks root_provider for the answers
  def number_generator(num, last, root_prov_pid) do

    send(root_prov_pid, {:num, num})

    if num < last do
      number_generator(num + 1, last, root_prov_pid)
    else
      nil
    end

  end

  #receives numbers and prints out their roots
  def root_provider() do

    receive do
      {:num, num} -> IO.puts "The square root of #{num} is #{sqrt (num)}"
    end

    root_provider()

  end

  #finds the square root of a number using two as the first estimate
  def sqrt(num) do
    sqrt(num, 2)
  end

  #finds the square root of a number using root_est as the first estimate
  def sqrt(num, root_est) do

    diff = :math.pow(root_est, 2) - num

    diff =
      if diff < 0 do
        -diff
      else
        diff
      end

      if diff < 0.00001 do
        root_est
      else
        next_est = root_est - ((:math.pow(root_est, 2) - num)/(2*root_est))
        sqrt(num, next_est)
      end

    end

  end
