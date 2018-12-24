module command;

/* Пример паттерна проектирования "Команда"
 * 
 * Краткое описание ситуации:
 *        Требуется создать API для пульта управления домашней автоматикой. На пульте есть 
 *        четырнадцать кнопок, сгруппированных по две, при этом на одну такую группу назначаются 
 *        команды включения/выключения чего-либо. Кроме того, есть кнопка отмены последней 
 *        поданной команды.
 * 
 * Официальное определение паттерна:
 *       "Паттерн Команда инкапсулирует запрос в виде объекта, делая возможной параметризацию
 *        клиентских объектов с другими запросами, организацию очереди или регистрацию запросов,
 *        а также поддержку отмены операций."
 * 
 * 
 *  Мои пояснения: 
 *        Некоторые вещи пришлось абсолютно переделать, кроме того, я добавил свои версии некоторых классов.
 */

// общий интерфейс всех команд
public interface Command
{
	public void execute();
	public void undo();
}


// команда-пустышка
public class NoCommand : Command
{
	void execute() 
	{

	}

	void undo()
	{

	}
}


// команда включения света
public class LightOnCommand : Command
{
private:
	Light light;

public:
	this(Light light)
	{
		this.light = light;
	}

	void execute()
	{
		light.on();
	}

	void undo()
	{
		light.off();
	}
}

// команда выключения света
public class LightOffCommand : Command
{
private:
	Light light;
	
public:
	this(Light light)
	{
		this.light = light;
	}
	
	void execute()
	{
		light.off();
	}

	void undo()
	{
		light.on();
	}
}


import std.stdio;

// свет
class Light
{
	private string location;

	this(string location)
	{
		this.location = location;
	}

	
	void on()
	{
		writefln("Light in %s is on", location);
	}

	void off()
	{
		writefln("Light in %s is off", location);
	}
}


// включить телевизор
public class TVOnCommand : Command
{
private:
	TV tv;
	
public:
	this(TV tv)
	{
		this.tv = tv;
	}
	
	void execute()
	{
		tv.on();
	}
	
	void undo()
	{
		tv.off();
	}
}


// выключить телевизор
public class TVOffCommand : Command
{
private:
	TV tv;
	
public:
	this(TV tv)
	{
		this.tv = tv;
	}

	void execute()
	{
		tv.off();
	}
	
	void undo()
	{
		tv.on();
	}
}


// телевизор
class TV
{
	private string location;
	
	this(string location)
	{
		this.location = location;
	}
	
	
	void on()
	{
		writefln("TV in %s is on", location);
	}
	
	void off()
	{
		writefln("TV in %s is off", location);
	}
}


// возможные скорости вентилятора
enum FanSpeed : int { OFF, LOW, MEDIUM, HIGH, ULTRAHIGH };


// вентилятор
public class CeilingFan
{
private:
	string location;
	int speed;

public:
	this(string location)
	{
		this.location = location;
		speed = FanSpeed.OFF;
	}

	void off()
	{
		speed = FanSpeed.OFF;
	}

	void low()
	{
		speed = FanSpeed.LOW;
	}

	
	void medium()
	{
		speed = FanSpeed.MEDIUM;
	}

	
	void high()
	{
		speed = FanSpeed.HIGH;
	}
	
	void ultra()
	{
		speed = FanSpeed.ULTRAHIGH;
	}
	
	int getSpeed()
	{
		return speed;
	}

	string getLocation()
	{
		return location;
	}
}


// вентилятор почти на максимум
class CeilingFanHighCommand : Command
{
private:
	CeilingFan ceilingFan;
	int previousSpeed;

public:
	this(CeilingFan ceilingFan)
	{
		this.ceilingFan = ceilingFan;
	}

	void execute()
	{
		previousSpeed = ceilingFan.getSpeed();
		ceilingFan.high();
		writefln("Ceiling fan in %s is high", ceilingFan.getLocation());
	}

	
	// реализация отмены с состоянием
	void undo()
	{
		switch(previousSpeed)
		{
			case FanSpeed.OFF:
				ceilingFan.off();
				writefln("Ceiling fan in %s is off", ceilingFan.getLocation());
				break;
			case FanSpeed.LOW:
				ceilingFan.low();
				writefln("Ceiling fan in %s is low", ceilingFan.getLocation());
				break;
			case FanSpeed.MEDIUM:
				ceilingFan.medium();
				writefln("Ceiling fan in %s is medium", ceilingFan.getLocation());
				break;
			case FanSpeed.HIGH:
				ceilingFan.high();
				writefln("Ceiling fan in %s is high", ceilingFan.getLocation());
				break;
			case FanSpeed.ULTRAHIGH:
				ceilingFan.ultra();
				writefln("Ceiling fan in %s is danger for you", ceilingFan.getLocation());
				break;
		}
	}
}


// вентилятор на минимум
class CeilingFanLowCommand : Command
{
private:
	CeilingFan ceilingFan;
	int previousSpeed;
	
public:
	this(CeilingFan ceilingFan)
	{
		this.ceilingFan = ceilingFan;
	}
	
	void execute()
	{
		previousSpeed = ceilingFan.getSpeed();
		ceilingFan.low();
		writefln("Ceiling fan in %s is low", ceilingFan.getLocation());
	}

	void undo()
	{
		switch(previousSpeed)
		{
			case FanSpeed.OFF:
				ceilingFan.off();
				writefln("Ceiling fan in %s is off", ceilingFan.getLocation());
				break;
			case FanSpeed.LOW:
				ceilingFan.low();
				writefln("Ceiling fan in %s is low", ceilingFan.getLocation());
				break;
			case FanSpeed.MEDIUM:
				ceilingFan.medium();
				writefln("Ceiling fan in %s is medium", ceilingFan.getLocation());
				break;
			case FanSpeed.HIGH:
				ceilingFan.high();
				writefln("Ceiling fan in %s is high", ceilingFan.getLocation());
				break;
			case FanSpeed.ULTRAHIGH:
				ceilingFan.ultra();
				writefln("Ceiling fan in %s is danger for you", ceilingFan.getLocation());
				break;
		}
	}
}


// макрокоманды - команды состоящие из множества команд
public class MacroCommand : Command
{
	private Command[] commands;

public:
	this(Command[] commands)
	{
		this.commands = commands;
	}

	void execute()
	{
		for (size_t i = 0; i < commands.length; i++)
		{
			commands[i].execute();
		}
	}

	void undo()
	{
		for (size_t i = 0; i < commands.length; i++)
		{
			commands[i].undo();
		}
	}
}


// пульт дистанционного управления домашней автоматикой
public class RemoteControlWithUndo
{
private:
	Command[] onCommands, offCommands;
	Command undoCommand;

public:
	this()
	{
		onCommands = new Command[7];
		offCommands = new Command[7];

		Command noCommand = new NoCommand();

		for (size_t i = 0; i < 7; i++)
		{
			onCommands[i] = noCommand;
			offCommands[i] = noCommand;
		}
		undoCommand = noCommand;
	}

	// назначить команды слоту
	void setCommand(int slot, Command onCommand, Command offCommand)
	{
		onCommands[slot] = onCommand;
		offCommands[slot] = offCommand;
	}

	
	// нажата некоторую кнопку включения
	void onButtonPressed(int slot)
	{
		onCommands[slot].execute();
		undoCommand = onCommands[slot];
	}

	
	// нажать некоторую кнопку выключения
	void offButtonPressed(int slot)
	{
		offCommands[slot].execute();
		undoCommand = offCommands[slot];
	}

	
	// нажать кнопку отмены
	void undoButtonPressed()
	{
		undoCommand.undo();
	}
}

unittest
{
	writeln("--- Command test ---");
	RemoteControlWithUndo remoteControl = new RemoteControlWithUndo();

	Light light1 = new Light("Living Room");
	Light light2 = new Light("Bath Room");
	Light light3 = new Light("Watercloset");

	CeilingFan ceilingFan = new CeilingFan("Living Room");

	TV tv1 = new TV("Living Room");
	TV tv2 = new TV("Bath Room");

	LightOnCommand lightOn1 = new LightOnCommand(light1);
	LightOnCommand lightOn2 = new LightOnCommand(light2);
	LightOnCommand lightOn3 = new LightOnCommand(light3);

	LightOffCommand lightOff1 = new LightOffCommand(light1);
	LightOffCommand lightOff2 = new LightOffCommand(light2);
	LightOffCommand lightOff3 = new LightOffCommand(light3);

	CeilingFanHighCommand ceilingFanHigh = new CeilingFanHighCommand(ceilingFan);
	CeilingFanLowCommand ceilingFanLow = new CeilingFanLowCommand(ceilingFan);

	TVOnCommand tvOn1 = new TVOnCommand(tv1);
	TVOffCommand tvOff1 = new TVOffCommand(tv1);

	TVOnCommand tvOn2 = new TVOnCommand(tv2);
	TVOffCommand tvOff2 = new TVOffCommand(tv2);

	Command[] commands1 = cast(Command[]) [lightOn1, lightOn2, lightOn3, tvOn1, tvOn2];
	Command[] commands2 = cast(Command[]) [lightOff1, lightOff2, lightOff3, tvOff1, tvOff2];
	MacroCommand allOn = new MacroCommand(commands1);
	MacroCommand allOff = new MacroCommand(commands2);

	remoteControl.setCommand(0, lightOn1, lightOff1);
	remoteControl.setCommand(1, lightOn2, lightOff2);
	remoteControl.setCommand(2, lightOn3, lightOff3);
	remoteControl.setCommand(3, ceilingFanHigh, ceilingFanLow);
	remoteControl.setCommand(4, tvOn1, tvOff1);
	remoteControl.setCommand(5, tvOn2, tvOff2);
	remoteControl.setCommand(6, allOn, allOff);

	writeln("Fan:");
	remoteControl.onButtonPressed(3);  // включить вентилятор
	writeln("Light:");
	remoteControl.onButtonPressed(1);  // включить в комнате
	writeln("Undo:");
	remoteControl.undoButtonPressed();  // отменить
	writeln("All On:");
	remoteControl.onButtonPressed(6);   // включить все
	writeln("All Off:");
	remoteControl.offButtonPressed(6);  // выключить все
	writeln("Undo:");
	remoteControl.undoButtonPressed();  // отменить
	writeln("TV:");
	remoteControl.offButtonPressed(4);  // выключить телевизор в комнате

}