module singleton;

/* Пример паттерна проектирования "Одиночка"
 * 
 * Краткое описание ситуации:
 *        Требуется создать модель нагревателя шоколада и обеспечиь существование только одного 
 *        такого нагревателя.
 * 
 * Официальное определение паттерна:
 *       "Паттерн Одиночка гарантирует, что класс имеет только один экземпляр, и
 *        предоставляет глобальную точку доступа к этому экземпляру"
 * 
 * 
 *  Мои пояснения: 
 *        потокобезопасная версия прилагается.
 */

import std.stdio;

// самый простой вариант
public class ChocolateBoiler
{
private:
	bool empty;
	bool boiled;
	static ChocolateBoiler chocolateBoiler = null;

	this()
	{
		empty = true;
		boiled = false;
	}

public:

	// заполнить нагреватель
	void fill()
	{
		if (isEmpty())
		{
			empty = false;
			boiled = false;
			writeln("Boiler filled.");
		}
	}

	// слить из нагревателя
	void drain()
	{
		if (!isEmpty() && isBoiled())
		{
			empty = true;
			writeln("Boiler drained.");
		}
	}

	// включить нагрев
	void boil()
	{
		if (!isEmpty() && !isBoiled())
		{
			boiled = true;
			writeln("Boil on.");
		}
	}

	// охладить
	void cool()
	{
		if (isBoiled())
		{
			boiled = false;
			writeln("Boil off.");
		}
	}

	// пустой ?
	bool isEmpty()
	{
		return empty;
	}

	// нагревается ?
	bool isBoiled()
	{
		return boiled;
	}

	// вернуть экземпляр нагревателя
	static ChocolateBoiler getBoiler()
	{
		if (chocolateBoiler is null)
		{
			chocolateBoiler = new ChocolateBoiler();
		}
		return chocolateBoiler;
	}
}

// потокобезопасный вариант 1 : добавляем синхронизацию
public class ChocolateBoiler2
{
private:
	bool empty;
	bool boiled;
	static ChocolateBoiler2 chocolateBoiler2 = null;
	
	this()
	{
		empty = true;
		boiled = false;
	}
	
public:
	
	// заполнить нагреватель
	void fill()
	{
		if (isEmpty())
		{
			empty = false;
			boiled = false;
			writeln("Boiler filled.");
		}
	}
	
	// слить из нагревателя
	void drain()
	{
		if (!isEmpty() && isBoiled())
		{
			empty = true;
			writeln("Boiler drained.");
		}
	}
	
	// включить нагрев
	void boil()
	{
		if (!isEmpty() && !isBoiled())
		{
			boiled = true;
			writeln("Boil on.");
		}
	}
	
	// охладить
	void cool()
	{
		if (isBoiled())
		{
			boiled = false;
			writeln("Boil off.");
		}
	}
	
	// пустой ?
	bool isEmpty()
	{
		return empty;
	}
	
	// нагревается ?
	bool isBoiled()
	{
		return boiled;
	}
	
	// вернуть экземпляр нагревателя
	static ChocolateBoiler2 getBoiler()
	{
		if (chocolateBoiler2 is null)
		{
			chocolateBoiler2 = new ChocolateBoiler2();
		}
		return chocolateBoiler2;
	}
}


unittest
{
	writeln("--- Singleton test ---");
	ChocolateBoiler chocolateBoiler = new ChocolateBoiler();
	chocolateBoiler.fill();
	chocolateBoiler.boil();
	chocolateBoiler.drain();
	chocolateBoiler.cool();

}