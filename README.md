## MemesCoin

A modern (opinionated) meme coin template suitable for forking to create your own.

## Opinions

- every community should have its own coin
- every coin should be ready to grow into governance
- minting should be periodic and mint limitations should be enforced

I was really happy to see the way $DEGEN capped the amount you could mint at any
one time and the subsequently spaced out how frequently you could mint. Their
scheme was to mint an initial supply of ~37B tokens then cap subsequent mints to
1% of the total supply (or an additional 3.7B) once per year (making the token
inflationary).

Here, I've opted to set a cap on the total every mintable (currently 10B), set
an initial supply of 100M (1% of the cap) and allow for an additional 100M
(again, 1%) to be minted per year. Some of these numbers draw on my experience
helping setting up DAOs like Collab.Land at [Origami](https://oinorigami.com) as
well as my experience with institutional investing schedules. That said, these
are the sorts of things that would be nice to make more configurable and as it
stands, you're welcome to fork and make changes to your heart's content

## Features

1. great developer experience using Foundry tooling
2. lightweight footprint due to using Solid-State Solidity libraries
3. diamond pattern storage, if you care about that sort of thing
4. governance-compatible and ready for delegating and individual and supply snap-shotting

## What's Next?

If there's community interest, it'd be easy to make this more configurable so
forking isn't necessary and you can generate new coins from a command line. Very
open to pull requests and issues describing feature requests.
