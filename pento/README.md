# Pento

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


##
curl --request POST      --url https://play.ht/api/v2/tts/stream      --header 'AUTHORIZATION: Bearer 8d684012667548f2a69d4f09e948f717'      --header 'X-USER-ID: 5BRME4ccMoVDYLqfEHKSrqmhNN23'      --header 'accept: audio/mpeg'      --header 'content-type: application/json'      --data '
{
  "output_format": "mp3", "text": "È opportuno che il conducente di un autoveicolo, in sosta sul lato destro di una strada urbana, ricordi al passeggero che apre la portiera di destra di fare attenzione ai pedoni in transito",
  "voice": "s3://voice-cloning-zero-shot/7ced805f-611e-433c-8c43-568f48a8af4e/original/manifest.json",
  "voice_engine": "PlayHT2.0-turbo"
}