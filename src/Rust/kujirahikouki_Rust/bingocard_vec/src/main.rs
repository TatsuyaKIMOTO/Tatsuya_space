//シャッフルするのに必要な宣言
use rand::seq::SliceRandom;

fn main() {
    //1から75までの数値をベクターに代入
    let mut nums = vec![];
    for i in 1..=75{
        nums.push(i);
    }

    //シャッフル
    let mut rng = rand::thread_rng();
    nums.shuffle(&mut rng);

    //カードを表示
    for i in 0..25{
        if i == 12{
            print!("  *,");
        }
        else{
            print!("{:3},", nums[i]);
        }
        if i % 5 == 4{
            println!("");
        }
    }
}
