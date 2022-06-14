defmodule Exlivery.Orders.CreateOrUpdateTest do
  use ExUnit.Case

  import Exlivery.Factory

  alias Exlivery.Orders.CreateOrUpdate, as: CreateOrUpdateOrder
  alias Exlivery.Users.Agent, as: UserAgent

  describe "call/1" do
    setup do
      Exlivery.start_agents()

      cpf = "00011122234"

      :user
      |> build(cpf: cpf)
      |> UserAgent.save()

      items = [
        build(:item),
        build(:item,
          description: "Temaki de atum",
          category: :japonesa,
          quantity: 2,
          unity_price: Decimal.new("20.50")
        )
      ]

      item1 = %{
        category: :pizza,
        description: "pizza de peperoni",
        quantity: 1,
        unity_price: 35.50
      }

      item2 = %{
        category: :pizza,
        description: "pizza de calabresa",
        quantity: 2,
        unity_price: 31.50
      }

      {:ok, user_cpf: cpf, items: items, item1: item1, item2: item2}
    end

    test "when all params are valid, saves the order", %{user_cpf: cpf, items: items} do
      params = %{user_cpf: cpf, items: items}
      response = CreateOrUpdateOrder.call(params)

      assert {:ok, _uuid} = response
    end

    test "when there is no user with given cpf, returns an error", %{items: items} do
      params = %{user_cpf: "00000000011", items: items}
      response = CreateOrUpdateOrder.call(params)

      assert {:error, "User not found"} = response
    end

    test "when there are invalid items, returns an error", %{
      user_cpf: cpf,
      item1: item1,
      item2: item2
    } do
      params = %{user_cpf: cpf, items: [%{item1 | quantity: 0}, item2]}
      response = CreateOrUpdateOrder.call(params)
      expected_response = {:error, "Invalid items"}
      assert response == expected_response
    end

    test "when there are no items, returns an error", %{user_cpf: cpf} do
      params = %{user_cpf: cpf, items: []}
      response = CreateOrUpdateOrder.call(params)
      expected_response = {:error, "Invalid parameters"}
      assert response == expected_response
    end
  end
end
