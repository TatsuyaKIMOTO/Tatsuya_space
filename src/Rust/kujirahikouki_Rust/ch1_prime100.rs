//Generate 100 prime numbers in Rust

//Definition of judge prime number
fn is_prime(n: usize) -> bool{
    for i in 2..n{
        if n % i == 0{
            return false
        }
    }
    return true
}

//Definition request 100 qty prime numbers
fn get_primes(primes: &mut[usize; 100]){
    let mut i = 2;
    let mut count = 0;
    //repeat until "count" reaches 100
    while count < 100{
        if is_prime(i){
            //add i at "count" order in primes arrangement[..,count]
            primes[count] = i;
            count += 1;
        }
        i += 1;
    }   
}

fn main(){
    //prepare 100 qty arrangement "0" as initial number, "100" as elements qty
    let mut primes = [0; 100];
    //Find 100 prime numbers
    get_primes(&mut primes);
    //Display result. In case print tuple or arrangements is shown, use {:?}
    println!("{:?}", primes);
}