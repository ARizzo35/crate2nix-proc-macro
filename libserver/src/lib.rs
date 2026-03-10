use rocket::get;
use rocket::launch;
use rocket::routes;

#[get("/")]
fn index() -> &'static str {
    "Hello, world!"
}

#[launch]
pub fn rocket() -> _ {
    rocket::build().mount("/", routes![index])
}
