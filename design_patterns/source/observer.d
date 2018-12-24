module observer;

/* Пример паттерна проектирования "Наблюдатель"
 * 
 * Краткое описание ситуации:
 *        Требуется создать API для погодной станции, которая имеет кучу разных 
 *        погодных информеров. Кроме того, должна быть возможность легкого добавления
 *        своих информеров и динамического их отображения.
 * 
 * Официальное определение паттерна:
 *       "Паттерн Наблюдатель определяет отношение "один-ко-многим" между объектами
 *        таким образом, что при изменении состояния одного объекта происходит автоматическое 
 *        оповещение и обновление всех зависимых объектов."
 * 
 *   Субъект - издатель, тот кто информирует объекты об обновлениях.
 *   Наблюдатель - подписчик, тот кто получает данные от издателя.
 * 
 * 
 *  Мои пояснения: 
 *        паттерн реализован в самом простом виде, кроме того, 
 *        класс статистики пришлось написать самому...
 */


// интерфейс, реализуемый субъектом
public interface Subject
{
	public void registerObserver(Observer observer);
	public void removeObserver(Observer observer);
	public void notifyObservers();
}


// интерфейс, реализуемый всеми наблюдателями
public interface Observer
{
	public void update(float temperature, float humidity, float pressure);
}


// интерфейс, реализуемый всеми объектами, имеющими визуальное представление
public interface DisplayElement
{
	public void display();
}

// класс субъекта
public class WeatherData : Subject
{
private:
	Observer[] observers;
	float temperature;
	float humidity;
	float pressure;

public:
	// список наблюдателей в начале пустой
	this()
	{
		observers = [];
	}

	// подписать некоторого наблюдателя на обновления
	void registerObserver(Observer observer)
	{
		observers ~= observer;
	}

	
	// отписать наблюдателя от обновлений
	void removeObserver(Observer observer)
	{
		// вспомогательная процедура удаления элемента из массива
		T[] remove(T)(T[] x, T y)
		{
			T[] tmp;
			foreach (elem; x)
			{
				if (elem != y) tmp ~= elem;
			}
			return tmp;
		}

		observers = remove(observers, observer);
	}

	// уведомить подписчиков об обновлении
	void notifyObservers()
	{
		try
		{
			foreach (observer; observers)
			{
				observer.update(temperature, humidity, pressure);
			}
		}
		catch
		{

		}
	}

	
	// данные измерений погоды изменились
	public void measurementsChanged()
	{
		notifyObservers();
	}

	// имитация поставки данных от новых измерений
	public void setMeasurements(float temperature, float humidity, float pressure)
	{
		this.temperature = temperature;
		this.humidity = humidity;
		this.pressure = pressure;
		measurementsChanged();
	}
}

import std.stdio;


// текущие погодные условия (первый наблюдатель)
public class CurrentConditionsDisplay : Observer, DisplayElement
{
private:
	float temperature;
	float humidity;
	Subject weatherData;

public:
	this(Subject weatherData)
	{
		this.weatherData = weatherData;
		weatherData.registerObserver(this);
	}

	void update(float temperature, float humidity, float pressure)
	{
		this.temperature = temperature;
		this.humidity = humidity;
		display();
	}

	void display()
	{
		writefln("Current conditions: %f F degrees and %f %% humidity", temperature, humidity);
	}
}


// статистика погоды (второй наблюдатель)
public class StatisticsDisplay : Observer, DisplayElement
{
private:
	float[] temperatures;
	Subject weatherData;

	float minimum(float[] arr)
	{
		if (arr.length <= 1)
		{
			return arr.length == 0 ? 0.0 : arr[0]; 
		}
		else
		{
			import std.algorithm : reduce, min;
			return reduce!min(arr);
		}
	}

	float maximum(float[] arr)
	{
		if (arr.length <= 1)
		{
			return arr.length == 0 ? 0.0 : arr[0]; 
		}
		else
		{
			import std.algorithm : reduce, max;
			return reduce!max(arr);
		}
	}

	float average(float[] arr)
	{
		if (arr.length == 0) return 0;
		else
		{
			import std.algorithm : sum;
			return sum(arr) / arr.length;
		}
	}

public:
	this(Subject weatherData)
	{
		this.weatherData = weatherData;
		weatherData.registerObserver(this);
	}

	
	void update(float temperature, float humidity, float pressure)
	{
		this.temperatures ~= temperature;
		display();
	}

	
	void display()
	{
		writefln("Min/Max/Avg : %f/%f/%f", minimum(temperatures), maximum(temperatures), average(temperatures));
	}
}


unittest
{
	writeln("--- Observer test ---");
	// создание субъекта
	WeatherData weatherData = new WeatherData();

	// погодные информеры
	CurrentConditionsDisplay currentDisplay = new CurrentConditionsDisplay(weatherData);
	StatisticsDisplay statisticsDisplay = new StatisticsDisplay(weatherData);

	// изменения погоды
	weatherData.setMeasurements(80, 65, 30.4);
	weatherData.setMeasurements(82, 70, 29.2);
	weatherData.setMeasurements(78, 90, 29.2);

	// мы не хотим больше видеть статистику на мониторе
	weatherData.removeObserver(statisticsDisplay);

	// новые измерения
	weatherData.setMeasurements(65, 65, 31.8);
	weatherData.setMeasurements(80, 50, 25.2);
	weatherData.setMeasurements(76, 70, 25.9);
}