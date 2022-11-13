#include <iostream>
#include <iomanip>
using namespace std;

int main()
{
    int i, j;

    for (i = 1; i < 10; i++){
        for (j =1; j < 10; j++){
            if (i > j)
                continue;//10行目のfor分のループに戻るか11行目の判定で決める。真ならループに戻って13行目の処理をしない。偽なら13行目の処理を実行する。
            cout << i << "X" << j << "=" << setw(2) << i*j << endl;
        }
        cout << "-----------------" << endl;
    }

    return 0;
}