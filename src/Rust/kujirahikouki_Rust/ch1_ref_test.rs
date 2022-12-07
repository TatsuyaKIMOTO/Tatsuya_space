fn main(){
    //input 10 in variable "v"
    let mut v = 10;
    
    //call def
    set_value(&mut v);
    
    //What is value of "v"?
    println!("v = {}",v);
}

//Definition modification arguement 100
fn set_value(arg: &mut u32){
    *arg = 100;
}