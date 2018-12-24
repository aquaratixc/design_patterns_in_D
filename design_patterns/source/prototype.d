module prototype;

/* Пример паттерна проектирования "Прототип"
 * 
 * Краткое описание ситуации:
 *        Требуется создать ряд запросов данных, однако, создание нового запроса слишком
 *        трудоемко и снижает быстродействие. Что делать ?
 * 
 * Официальное определение паттерна:
 *       "Паттерн Прототип определяет, задает виды создаваемых объектов с помощью интерфейса 
 *        некоторого экземпляра-прототипа, и создает новые объекты путем копирования (клонирования) 
 *        этого экземпляра"
 * 
 * 
 *  Мои пояснения: 
 *        В D я не нашел методов для копирования объекта, однако, в интернете нашел интересный метод для 
 *        реализации подобного. Кроме того, возможно, определение в заголовке не является официальным и
 *        реализация самого паттерна половинная - так как должен быть реализован еще и сам клиент.
 */

extern (C) Object _d_newclass(ClassInfo info);

// поверхностное копирование объекта
template shallow_copy (T : Object)
{
	T shallow_copy (T value)
	{
		if (value is null)
			return null;
		
		void* copy = cast(void*) _d_newclass(value.classinfo);
		size_t size = value.classinfo.init.length;
		
		copy[0 .. size] = (cast(void*) value)[0 .. size];
		return cast(T) copy;
	}
}


interface Cloneable(T)
{
	T clone();
}


public class Request : Cloneable!Request
{
private:
	string clientName;
	uint ageOfClient;
	string jobOfClient;

public:
	this(string clientName, uint ageOfClient, string jobOfClient)
	{
		this.clientName = clientName;
		this.ageOfClient = ageOfClient;
		this.jobOfClient = jobOfClient;
	}

	Request clone()
	{
		return shallow_copy(this);
	}

	string getName()
	{
		return clientName;
	}

	void setName(string clientName)
	{
		this.clientName = clientName;
	}

	
	uint getAge()
	{
		return ageOfClient;
	}
	
	void setAge(uint ageOfClient)
	{
		this.ageOfClient = ageOfClient;
	}

	
	string getJob()
	{
		return jobOfClient;
	}
	
	void setJob(string jobOfClient)
	{
		this.jobOfClient = jobOfClient;
	}
}


unittest
{
	import std.stdio;
	writeln("--- Prototype test ---");
	Request request = new Request("Dart Vader", 45, "Star of Death"); // слишком затратный ресурс

	auto userRequest = request.clone(); // создание объекта слишком затратно, потому просто его клонируем
	writefln("name = %s, age = %d, job = %s", userRequest.getName(), userRequest.getAge(), userRequest.getJob());
	userRequest.setAge(140); // изменяем состояние клона
	writefln("name = %s, age = %d, job = %s", userRequest.getName(), userRequest.getAge(), userRequest.getJob());
	auto userRequest2 = request.clone();
	writefln("name = %s, age = %d, job = %s", userRequest2.getName(), userRequest2.getAge(), userRequest2.getJob());
	
}