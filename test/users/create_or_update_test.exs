defmodule Exlivery.Users.CreateOrUpdateTest do
  use ExUnit.Case

  alias Exlivery.Users.Agent, as: UserAgent
  alias Exlivery.Users.CreateOrUpdate

  describe "call/1" do
    setup do
      UserAgent.start_link(%{})

      :ok
    end

    test "when all the params are valid, saves the user" do
      params = %{
        name: "Thiago Oliveira",
        email: "thiagoomarcal@gmail.com",
        cpf: "12345678900",
        age: 27,
        address: "Rua Comandante vitor, 160"
      }

      response = CreateOrUpdate.call(params)
      expected_response = {:ok, "User created or updated sucessfully"}

      assert response == expected_response
    end

    test "when there are invalid params, returns an error" do
      params = %{
        name: "Luiza Oliveira",
        email: "luizaomarcal@gmail.com",
        cpf: "17896548922",
        age: 17,
        address: "Rua Comandante vitor, 160"
      }

      response = CreateOrUpdate.call(params)
      expected_response = {:error, "Invalid parameters"}

      assert response == expected_response
    end
  end
end
