// 配列をシャッフルするのに必要な宣言
use rand::seq::SliceRandom;

fn main() {
    //1から75までの数値を配列に代入
    let mut nums = [0; 75]; //初期値０で要素数75個の配列numsを用意する
    for i in 1..=75{
        nums[i-1] = i; //1から75までの数値iを配列numsの0から順に入れていく
    }
    //シャッフルする
    let mut rng = rand::thread_rng();
    nums.shuffle(&mut rng); //ミュータブルな引数をとるときは&mut 変数 としてアンバサンドをつける

    //カードを表示させる
    for y in 0..5{
        for x in 0..5{
            let i = y*5+x;
            if i == 12{//ワイルドカードを12番13番目にセットする
                print!(" *,");
            }else{
                print!("{:3},",nums[i]);
            }
        }
        println!("");
    }
}
