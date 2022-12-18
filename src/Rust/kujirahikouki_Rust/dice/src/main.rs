//Rustでサイコロを振るプログラム
//randクレートのRngを利用
use rand::Rng;

fn main() {
    //乱数の生成器を用意
    let mut rng = rand::thread_rng();
    //5回サイコロを振る
    for _ in 0..5{
        //1から6の乱数を生成
        let dice = rng.gen_range(1..=6);
        println!("{}", dice);
    }
}