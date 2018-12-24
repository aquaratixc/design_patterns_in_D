module decorator;

/* Пример паттерна проектирования "Декоратор"
 * 
 * Краткое описание ситуации:
 *        Требуется создать систему, которая могла бы подсчитывать стоимость кофейных
 *        напитков, а также опциональных дополнений, заказываемых пользователем.
 *        Напитки могут быть расширены впоследствии, как впрочем и дополнения.
 * 
 * Официальное определение паттерна:
 *       "Паттерн Декоратор динамически наделяет объект новыми возможностями и
 *        является гибкой альтернативой субклассированию в области расширения
 *        функциональности"
 * 
 * 
 *  Мои пояснения: 
 *        паттерн реализован как есть, кроме того, пришлось немного поменять модификаторы доступа,
 *        так как в D все немного иначе, чем в Java
 */


// общее представление напитка
public abstract class Beverage
{
	// описание напитка
	protected string description = "Unknown beverage";

	// получить описание напитка
	public string getDescription()
	{
		return description;
	}

	// стоимость напитка
	public abstract double cost();
}


// опциональные дополнения к напитку
public abstract class CondimentDecorator : Beverage
{
	public abstract string getDescription();
}


// кофе "эспрессо"
public class Espresso : Beverage
{
	this()
	{
		description = "Espresso";
	}

	public double cost()
	{
		return 1.99;
	}
}


// домашняя смесь (хз что это такое)
public class HouseBlend : Beverage
{
	this()
	{
		description = "House Blend Coffee";
	}
	
	public double cost()
	{
		return .89;
	}
}


// темная обжарка
public class DarkRoast : Beverage
{
	this()
	{
		description = "Dark Roast Coffee";
	}
	
	public double cost()
	{
		return .99;
	}
}


// кофе без кофеина
public class Decaf : Beverage
{
	this()
	{
		description = "Coffee without Caffeine";
	}
	
	public double cost()
	{
		return 1.05;
	}
}


// шоколадное дополнение
public class Mocha : CondimentDecorator
{
	private Beverage beverage;

	this(Beverage beverage)
	{
		this.beverage = beverage;
	}

	public string getDescription()
	{
		return beverage.getDescription() ~ ", Mocha";
	}

	
	public double cost()
	{
		return beverage.cost() + 0.20;
	}
}


// соевое дополнение
public class Soy : CondimentDecorator
{
	private Beverage beverage;
	
	this(Beverage beverage)
	{
		this.beverage = beverage;
	}
	
	public string getDescription()
	{
		return beverage.getDescription() ~ ", Soy";
	}
	
	public double cost()
	{
		return beverage.cost() + .15;
	}
}


// дополнение в виде взбитых сливок
public class Whip : CondimentDecorator
{
	private Beverage beverage;
	
	this(Beverage beverage)
	{
		this.beverage = beverage;
	}
	
	public string getDescription()
	{
		return beverage.getDescription() ~ ", Whip";
	}
	
	
	public double cost()
	{
		return beverage.cost() + .10;
	}
}

unittest
{
	import std.stdio;

	writeln("--- Decorator test ---");

	Beverage beverage1 = new DarkRoast(); // темная обжарка
	// собственно тут и происходит декорирование, т.е оборачивание одного объекта в другой
	beverage1 = new Mocha(beverage1);
	beverage1 = new Mocha(beverage1); // с двойным шоколадом
	beverage1 = new Whip(beverage1);  // со взбитыми сливками
	writefln(beverage1.getDescription() ~ " $ %f", beverage1.cost());

	Beverage beverage2 = new Decaf(); // кофе без кофеина
	beverage2 = new Whip(beverage2);  // со взбитыми сливками
	beverage2 = new Soy(beverage2);   // с соей. наверно, надо быть полным деградантом чтоб такое пить...
	writefln(beverage2.getDescription() ~ " $ %f", beverage2.cost());

	Beverage beverage3 = new Espresso(); // простой эспрессо
	writefln(beverage3.getDescription() ~ " $ %f", beverage3.cost());
}