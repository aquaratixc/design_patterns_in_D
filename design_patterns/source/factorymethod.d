module factorymethod;

/* Пример паттерна проектирования "Фабричный метод"
 * 
 * Краткое описание ситуации:
 *        Требуется создать сеть пиццерий, которая имеет практически унифицированные рецепт 
 *        приготовления пиццы, однако, должна учитывать и региональные различия в используемых
 *        компонентах и некоторых фазах рецепта.
 * 
 * Официальное определение паттерна:
 *       "Паттерн Фабричный метод определяет интерфейс создания объекта, но позволяет
 *        субклассам выбрать класс создаваемого экземпляра. Таким образом, Фабричный
 *        метод делегирует операцию создания экземпляра субклассам."
 * 
 * 
 *  Мои пояснения: 
 *        Часть кода заккоментирована, так как я понятия не имею, из каких ингредиентов
 *        и по какому рецепту делаются остальные виды пиццы.
 */


// общий класс для различных видов пиццерий
public abstract class PizzaStore
{
	// рецепт приготовления пиццы прописан тут
	public Pizza orderPizza(string type)
	{
		Pizza pizza;

		pizza = createPizza(type);

		pizza.prepare();
		pizza.bake();
		pizza.cut();
		pizza.box();

		return pizza;
	}

	// вот эта штука и называется фабричным методом
	protected abstract Pizza createPizza(string type);
}


// нью-йоркская пиццерия
public class NYPizzaStore : PizzaStore
{
	override Pizza createPizza(string item)
	{
		switch(item)
		{
			case "cheese":
				return new NYStyleCheesePizza();
				//			case "veggie":
				//				return NYStyleVeggiePizza();
				//			case "clam":
				//				return NYStyleClamPizza();
				//			case "pepperoni":
				//				return NYStylePepperoniPizza();
			default:
				return null;
		}
	}
}


// чикагская пиццерия
public class ChicagoPizzaStore : PizzaStore
{
	override Pizza createPizza(string item)
	{
		switch(item)
		{
			case "cheese":
				return new ChicagoStyleCheesePizza();
				//			case "veggie":
				//				return ChicagoStyleVeggiePizza();
				//			case "clam":
				//				return ChicagoStyleClamPizza();
				//			case "pepperoni":
				//				return ChicagoStylePepperoniPizza();
			default:
				return null;
		}
	}
}

import std.stdio;


// общий класс для всех типов пицц
public abstract class Pizza
{
protected:
	string name; // название пиццы
	string dough; // тип основы
	string sauce; // соус
	string[] toppings;  // добавки

public:
	// приготовление пиццы
	void prepare()
	{
		writeln("Preparing " ~ name);
		writeln("Tossing dough...");
		writeln("Adding toppings:");
		try
		{
			foreach (topping; toppings)
			{
				writeln("    " ~ topping);
			}
		}
		catch (Throwable)
		{

		}
	}

	
	// выпекание пиццы
	void bake()
	{
		writeln("Bake for 25 minutes at 350 degrees");
	}

	
	// нарезание пиццы
	void cut()
	{
		writeln("Cutting the pizza into diagonal slices");
	}

	
	// упаковка пиццы
	void box()
	{
		writeln("Place pizza in official PizzaStore Box");
	}

	
	// получить название пиццы
	string getName()
	{
		return name;
	}
}


// нью-йоркская пицца с сыром: тонкая основа, соус маринара, сыр реджано
public class NYStyleCheesePizza : Pizza
{
	this()
	{
		name = "NY Style Sauce and Cheese Pizza";
		dough = "Thin Crust Dough";
		sauce = "Marinara Sauce";
		toppings ~= "Grated Reggiano Cheese";
	}
}


// чикагская пицца с сыром: толстая основа, томатный соус, много сыра моццарелла
public class ChicagoStyleCheesePizza : Pizza
{
	this()
	{
		name = "Chicago Style Deep Dish Cheese Pizza";
		dough = "Extra Thick Crust Dough";
		sauce = "Plum Tomato Sauce";
		toppings ~= "Shredded Mozzarella Cheese";
	}

	// в Чикаго пиццу нарезают квадратиками
	override void cut()
	{
		writeln("Cutting the pizza into square slices");
	}
}


unittest
{
	writeln("--- Factory Method test ---");
	PizzaStore nyStore = new NYPizzaStore();
	PizzaStore chicagoStore = new ChicagoPizzaStore();

	Pizza pizza = nyStore.orderPizza("cheese");
	writeln();
	pizza = chicagoStore.orderPizza("cheese");
}
