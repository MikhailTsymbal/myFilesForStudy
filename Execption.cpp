//Разработать класс для представления рациональных чисел и внедрить его в систему типов языка С++ 
//так, чтобы им можно было пользоваться естественным образом
#include <iostream>
#include <numeric>
using namespace std;
class Rational {
public:
    Rational() {
        p = 0;
        q = 0;
    }

    Rational(int numerator, int denominator) {
        p = numerator;
        q = denominator;
    }

    int Numerator() const {
        if (p == 0)
            return 0;
        if (q < 0)
            return -p / gcd(p, q % p);
        else
            return p / gcd(p, q % p);
    }

    int Denominator() const {
        if (p == 0)
            return 1;
        if (q < 0)
            return (-1) * q / gcd(p, q % p);
        else
            return q / gcd(p, q % p);
    }
private:
    int p;
    int q;
};

Rational operator+ (const Rational& lhs, const Rational& rhs)
{
    return Rational(lhs.Numerator() * rhs.Denominator() + rhs.Numerator() * lhs.Denominator(), lhs.Denominator() * rhs.Denominator());
}

Rational operator- (const Rational& lhs, const Rational& rhs) {
    return Rational(lhs.Numerator() * rhs.Denominator() - rhs.Numerator() * lhs.Denominator(), lhs.Denominator() * rhs.Denominator());
}
Rational operator* (const Rational& lhs, const Rational& rhs) {
    return Rational(lhs.Numerator() * rhs.Numerator(), lhs.Denominator() * rhs.Denominator());
}
Rational operator/ (const Rational& lhs, const Rational& rhs) {
    return Rational(lhs.Numerator() * rhs.Denominator(), lhs.Denominator() * rhs.Numerator());
}

bool operator== (const Rational& lhs, const Rational& rhs) {
    if ((lhs.Numerator() == rhs.Numerator()) && (lhs.Denominator() == rhs.Denominator()))
        return true;
    else
        return false;
}
int main() {
    {
        Rational a(2, 3);
        Rational b(4, 3);
        Rational c = a * b;
        bool equal = c == Rational(8, 9);
        if (!equal) {
            cout << "2/3 * 4/3 != 8/9" << endl;
            return 1;
        }
    }

    {
        Rational a(5, 4);
        Rational b(15, 8);
        Rational c = a / b;
        bool equal = c == Rational(2, 3);
        if (!equal) {
            cout << "5/4 / 15/8 != 2/3" << endl;
            return 2;
        }
    }

    cout << "OK" << endl;
    return 0;
}