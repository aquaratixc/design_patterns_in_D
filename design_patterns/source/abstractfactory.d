module abstractfactory;

/* Пример паттерна проектирования "Абстрактная фабрика"
 * 
 * Краткое описание ситуации:
 *        Требуется создать сеть пиццерий, которая имеет практически унифицированные рецепт 
 *        приготовления пиццы, однако, должна учитывать и региональные различия в используемых
 *        компонентах и некоторых фазах рецепта.
 * 
 * Официальное определение паттерна:
 *       "Паттерн Абстрактная Фабрика предоставляет интерфейс создания семейств взаимосвязанных или
 *       взаимозависимых объектов без указания их семейства"
 * 
 * 
 *  Мои пояснения: 
 *        Часть кода написана своими руками, часть кода удалена. Есть еще проблема: тип нарезки пиццы для чикаго 
 *        потерялся, однако, это исправимо вводом новой фабрики для фирменной нарезки пиццы.
 */

// интерфейс поставщиков компонентов
public interface PizzaIngredientFactory
{
	public Dough createDough();
	public Sauce createSauce();
	public Cheese createCheese();
	public Clam createClam();
}

// нью-йоркский поставщик ингредиентов
public class NYPizzaIngredientFactory : PizzaIngredientFactory
{
	public Dough createDough()
	{
		return new ThinDough();
	}

	public Sauce createSauce()
	{
		return new MarinaraSauce();
	}

	public Cheese createCheese()
	{
		return new ReggianoCheese();
	}

	public Clam createClam()
	{
		return new FreshClam();
	}
}

// чикагский поставщик ингредиентов
public class ChicagoPizzaIngredientFactory : PizzaIngredientFactory
{
	public Dough createDough()
	{
		return new ThickDough();
	}
	
	public Sauce createSauce()
	{
		return new TomateSauce();
	}
	
	public Cheese createCheese()
	{
		return new MozzarellaCheese();
	}
	
	public Clam createClam()
	{
		return new FreezeClam();
	}
}

import std.stdio;

// прародитель всех пицц
public abstract class Pizza
{
protected:
	string name;
	Dough dough;
	Sauce sauce;
	Cheese cheese;
	Clam clam;

public:
	abstract void prepare();

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

	void setName(string name)
	{
		this.name = name;
	}
}

// пицца с сыром
public class CheesePizza : Pizza
{
protected:
	PizzaIngredientFactory ingredientFactory;

public:
	this(PizzaIngredientFactory ingredientFactory)
	{
		this.ingredientFactory = ingredientFactory;
	}

	void prepare()
	{
		writeln("Preparing " ~ name);
		dough = ingredientFactory.createDough();
		sauce = ingredientFactory.createSauce();
		cheese = ingredientFactory.createCheese();
		clam = ingredientFactory.createClam();
	}
}

// пицца с мидиями
public class ClamPizza : Pizza
{
protected:
	PizzaIngredientFactory ingredientFactory;
	
public:
	this(PizzaIngredientFactory ingredientFactory)
	{
		this.ingredientFactory = ingredientFactory;
	}
	
	void prepare()
	{
		writeln("Preparing " ~ name);
		dough = ingredientFactory.createDough();
		sauce = ingredientFactory.createSauce();
		cheese = ingredientFactory.createCheese();
		clam = ingredientFactory.createClam();
	}
}


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

	protected abstract Pizza createPizza(string type);
}

// нью-йоркская пиццерия
public class NYPizzaStore : PizzaStore
{
	protected Pizza createPizza(string item)
	{
		Pizza pizza = null;
		PizzaIngredientFactory ingredientFactory = new NYPizzaIngredientFactory(); 

		switch(item)
		{
			case "cheese":
				pizza = new CheesePizza(ingredientFactory);
				pizza.setName("NY Style Cheese Pizza");
				break;
			case "clam":
				pizza = new ClamPizza(ingredientFactory);
				pizza.setName("NY Style Clam Pizza");
				break;
			default:
				pizza = null;
				break;
		}
		return pizza;
	}
}


// чикагская пиццерия
public class ChicagoPizzaStore : PizzaStore
{
	protected Pizza createPizza(string item)
	{
		Pizza pizza = null;
		PizzaIngredientFactory ingredientFactory = new ChicagoPizzaIngredientFactory(); 

		switch(item)
		{
			case "cheese":
				pizza = new CheesePizza(ingredientFactory);
				pizza.setName("Chicago Style Cheese Pizza");
				break;
			case "clam":
				pizza = new ClamPizza(ingredientFactory);
				pizza.setName("Chicago Style Clam Pizza");
				break;
			default:
				pizza = null;
				break;
		}
		return pizza;
	}
}

// тип основы
interface Dough
{

}

// тонкая основа
class ThinDough : Dough
{

	this()
	{
		writeln("  ---> Thin Dough");
	}
}

// толстая основа
class ThickDough : Dough
{
	
	this()
	{
		writeln("  ---> Thick Dough");
	}
}


// тип соуса
interface Sauce
{

}

// соус маринара
class MarinaraSauce : Sauce
{
	
	this()
	{
		writeln("  ---> Marinara Sauce");
	}
}

// томатный соус
class TomateSauce : Sauce
{
	
	this()
	{
		writeln("  ---> Tomate Sauce");
	}
}

// тип сыра
interface Cheese
{

}

// сыр реджано
class ReggianoCheese : Cheese
{
	
	this()
	{
		writeln("  ---> Reggiano Cheese");
	}
}

// сыр моццарелла
class MozzarellaCheese : Cheese
{
	
	this()
	{
		writeln("  ---> Mozzarella Cheese");
	}
}

// тип мидий (!)
interface Clam
{

}

// мидии - свежие
class FreshClam : Clam
{
	
	this()
	{
		writeln("  ---> Fresh Clam");
	}
}


// мидии в консервах
class FreezeClam : Clam
{
	
	this()
	{
		writeln("  ---> Freeze Clam");
	}
}


unittest
{
	writeln("--- Abstract Factory test ---");
	PizzaStore nyStore = new NYPizzaStore();
	PizzaStore chicagoStore = new ChicagoPizzaStore();
	
	Pizza pizza = nyStore.orderPizza("cheese");
	writeln();
	pizza = chicagoStore.orderPizza("cheese");
	writeln();
	pizza = nyStore.orderPizza("clam");
}