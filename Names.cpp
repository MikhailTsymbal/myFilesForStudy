//Реализуйте класс для человека, поддерживающий историю изменений человеком своих фамилии и имени.
//Считайте, что в каждый год может произойти не более одного изменения фамилии и не более одного
//изменения имени.При этом с течением времени могут открываться всё новые факты из прошлого человека,
//поэтому года́ в последовательных вызовах методов ChangeLastName и ChangeFirstName не обязаны возрастать.
//Гарантируется, что все имена и фамилии непусты.
//Строка, возвращаемая методом GetFullName, должна содержать разделённые одним пробелом
//имя и фамилию человека по состоянию на конец данного года.
//Если к данному году не случилось ни одного изменения фамилии и имени, верните строку "Incognito".
//Если к данному году случилось изменение фамилии, но не было ни одного изменения имени, 
//верните "last_name with unknown first name".
//Если к данному году случилось изменение имени, но не было ни одного изменения фамилии,
//верните "first_name with unknown last name".
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <map>
#include <iomanip>
using namespace std;
class Person {
public:
    void ChangeFirstName(int year, const string& first_name) {
        firstname[year] = first_name;
        if (min_firstname > year)
            min_firstname = year;
    }
    void ChangeLastName(int year, const string& last_name) {
        lastname[year] = last_name;
        if (min_lastname > year)
            min_lastname = year;
        // добавить факт изменения фамилии на last_name в год year
    }
    string GetFullName(int year) {
        if ((year < min_firstname) && (year < min_lastname))
            return "Incognito";
        if ((year >= min_firstname) && (year < min_lastname))
        {
            for (auto z : firstname)
            {

                if (year >= z.first)
                {
                    q = z.second;
                }
            }
            return q + " with unknown last name";
        }
        if ((year < min_firstname) && (year >= min_lastname))
        {
            for (auto k : lastname)
            {

                if (year >= k.first)
                {
                    f = k.second;
                }
            }
            return f + " with unknown first name";
        }
        if ((year >= min_firstname) && (year >= min_lastname))
        {

            for (auto z : firstname)
            {

                if (year >= z.first)
                {
                    q = z.second;
                }
            }
            for (auto k : lastname)
            {

                if (year >= k.first)
                {
                    f = k.second;
                }
            }

            return q + " " + f;
        }
    }
private:
    map <int, string> lastname;
    map <int, string> firstname;
    int year_firstname, min_firstname = 9999999;
    int year_lastname, min_lastname = 9999999;

    string result;
    string f;
    string q;
    int count = 0;
};

int main() {
    Person person;

    person.ChangeFirstName(1965, "Polina");
    person.ChangeLastName(1967, "Sergeeva");
    for (int year : {1900, 1965, 1990}) {
        cout << person.GetFullName(year) << endl;
    }

    person.ChangeFirstName(1970, "Appolinaria");
    for (int year : {1969, 1970}) {
        cout << person.GetFullName(year) << endl;
    }

    person.ChangeLastName(1968, "Volkova");
    for (int year : {1969, 1970}) {
        cout << person.GetFullName(year) << endl;
    }

    return 0;
}
