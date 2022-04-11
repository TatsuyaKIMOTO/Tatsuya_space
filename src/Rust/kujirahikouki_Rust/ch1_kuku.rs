//Rustで九九の表を作成
fn main(){
    for y in 1..10{
        for x in 1..10{
            print!("{:3},",x*y);//print!は改行しないマクロなのでこちらを使用している。println!は改行するマクロ。
        }
        println!("");//println!マクロで改行を実行している。
    }
}