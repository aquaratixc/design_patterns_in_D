module strategy;

/* Пример паттерна проектирования "Стратегия"
 * 
 * Краткое описание ситуации:
 *       Требуется создать симулятор уток, который бы демонстрировал поведение самых разных типов уток,
 *       позволяя на ходу изменить их поведение. Кроме того, симулятиор должен быть легко расширяемым
 *       и гибким.
 *
 * Официальное определение паттерна:
 *       "Паттерн Стратегия определяет семейство алгоритмов, инкапсулирует каждый из них
 *       и обеспечивает их взаимозаменяемость. Он позвоялет модифицировать алгоритмы независимо 
 *       от их использования на стороне клиента"
 * 
 * 
 *  Мои пояснения: 
 *       в роли семейства алгоритмов выступают классы реализующие различные виды крякания и
 *       полета. Кроме того, я слегка модифицировал пример приведенный в книге "Head First Design Patterns" 
 *       в пользу большей защищенности и правильности кода.
 */

// интерфейс, реализуемый всеми классами способными летать
interface FlyBehavior
{
	void fly();
}


// интерфейс, реализуемый всеми классами способными крякать
interface QuackBehavior
{
	void quack();
}


import std.stdio;

// класс, определяющий полет с помощью крыльев
class FlyWithWings : FlyBehavior
{
	void fly()
	{
		writeln("I am flying !");
	}
}


// класс, определяющий не способных к полету
class FlyNoWay : FlyBehavior
{
	void fly()
	{
		// пустая реализация
	}
}


// класс, определяющий тех, кто способен крякать
class Quack : QuackBehavior
{
	void quack()
	{
		writeln("Quack !");
	}
}


// класс, определяющий тех, кто способен пищать
class Squeak : QuackBehavior
{
	void quack()
	{
		writeln("Squeak !");
	}
}


// класс, определяющий тех, кто не способен крякать
class MuteQuack : QuackBehavior
{
	void quack()
	{
		// пустая реализация
	}
}


// утка
abstract class Duck
{
	// объявляем переменные с типом _интерфейса_ поведения
	protected FlyBehavior flyBehavior;
	protected QuackBehavior quackBehavior;

	
	void performFly()
	{
		// делегируем выполнение операций объекту интерфейса
		flyBehavior.fly();
	}

	
	void performQuack()
	{
		// делегируем выполнение операций объекту интерфейса
		quackBehavior.quack();
	}

	// возможность динамического изменения типа полета
	void setFlyBehavior(FlyBehavior flyBehavior)
	{
		this.flyBehavior = flyBehavior;
	}

	// возможность динамического изменения типа крякания
	void setQuackBehavior(QuackBehavior quackBehavior)
	{
		this.quackBehavior = quackBehavior;
	}

	abstract void swim();
}

// конкретный класс уток
class MallardDuck : Duck
{
	// вот здесь и происходит инкапсуляция поведения
	this()
	{
		// переменные quackBehavior и flyBehavior наследуются от класса Duck
		// при этом выполнение методов quack() и fly() возлагается на конкретные объекты классов Quack() и FlyWithWings()
		quackBehavior = new Quack();
		flyBehavior = new FlyWithWings();
	}

	override void swim()
	{
		writeln("I swim in sea");
	}
}


// резиновая утка
class RubberDuck : Duck
{
	this()
	{
		quackBehavior = new Squeak();
		flyBehavior = new FlyNoWay();
	}

	override void swim()
	{
		writeln("I swim in bathroom");
	}
}


unittest 
{
	writeln("--- Strategy test ---");
	// тестирование обычной утки
	MallardDuck mallardDuck = new MallardDuck();

	mallardDuck.performQuack(); // крякает
	mallardDuck.performFly();   // способна к полету

	// тестирование резиновой утки
	RubberDuck rubberDuck = new RubberDuck();

	rubberDuck.performQuack();  // пищит
	rubberDuck.performFly();    // летать не способна

	rubberDuck.setQuackBehavior(new MuteQuack()); // теперь утка пищать не будет

	rubberDuck.performQuack(); //  действительно, не пищит

	mallardDuck.setFlyBehavior(new FlyNoWay()); // допустим обычной утке прострелили крыло
	mallardDuck.performFly(); // летать она уже не способна

	mallardDuck.setQuackBehavior(new Squeak());
	mallardDuck.performQuack(); // и зачем мы мучаем уток ?
}
