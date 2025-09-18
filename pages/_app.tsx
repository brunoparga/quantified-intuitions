import "../styles/globals.css";

import Head from "next/head";
import NextNProgress from 'nextjs-progressbar';

import type { AppProps } from "next/app";

function MyApp({
  Component,
  pageProps,
}: AppProps) {
  return (
    <>
      <Head>
        <title>The Estimation Game</title>
      </Head>
      <NextNProgress color="#4f46e5" showOnShallow={true} height={2} options={{ trickle: true, showSpinner: false }} />
      <Component {...pageProps} />
    </>
  );
}

export default MyApp;
