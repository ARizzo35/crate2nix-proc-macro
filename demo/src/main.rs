use anyhow::Result;

#[rocket::main]
async fn main() -> Result<()> {
    let _ = libserver::rocket().launch().await?;

    Ok(())
}
