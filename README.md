# Personal Contract 

## Installation
Ensure you have `npm` installed.

Clone the repo and in the repo install the [nx CLI](https://nx.dev/latest/react/getting-started/intro) by running:
```bash
npm install -g @nrwl/cli
```

Then install [remixd](https://github.com/ethereum/remixd) with:
```bash
npm install @remix-project/remixd
```

With `nx` installed you should be able to run `remixd`. 
To serve this directory to remix run:

```bash
npx remixd -s path-to-directory --remix-ide url-of-remix
```

For example if you're accesing remix through `https://remix.ethereum.org/`
and are in the repo directory, you would run:
```bash
npx remixd -s . --remix-ide https://remix.ethereum.org
```


## In Remix
Select the file explorer from the navigation on the left and use the dropdown to change from *default_orkspace* and click *- connect to localhost -*.

You'll see a pop-up that tells you how to run remixd. It will search on port 65520 by default which is what `remixd` should serve on. Click *connect* and it should connect to the directory. From there you can do all your work in remix.
