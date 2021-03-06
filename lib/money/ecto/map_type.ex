if Code.ensure_compiled?(Ecto.Type) do
  defmodule Money.Ecto.Map.Type do
    @moduledoc """
    Provides a type for Ecto to store a multi-currency price.
    The underlying data type should be a map(JSON).
    Suitable for databases that do not support composite types, but support JSON (e.g. MySQL).

    ## Migration Example

        reate table(:my_table) do
          add :price, :map
        end

    ## Schema Example

        schema "my_table" do
          field :price, Money.Ectso.Map.Type
        end
    """

    @behaviour Ecto.Type

    defdelegate cast(money), to: Money.Ecto.Composite.Type

    @spec type() :: :map
    def type, do: :map

    @spec dump(any()) :: :error | {:ok, {integer(), String.t()}}
    def dump(%Money{} = money) do
      {:ok, %{"amount" => money.amount(), "currency" => to_string(money.currency)}}
    end

    def dump(_), do: :error

    @spec load(map()) :: {:ok, Money.t()}
    def load(%{"amount" => amount, "currency" => currency}) when is_integer(amount) do
      {:ok, Money.new(amount, currency)}
    end

    def load(%{"amount" => amount, "currency" => currency}) when is_binary(amount) do
      {:ok, Money.new(String.to_integer(amount), currency)}
    end
  end
end
