import { DefaultSeo } from "next-seo";

export const Meta = () => {
  return (
    <DefaultSeo
      titleTemplate="%s - Estimation Game"
      defaultTitle="Estimation Game"
      description="Quantified Intuitions helps you practice assigning credences to outcomes with a quick feedback loop."
      canonical="https://estimation.annetatargalt.ee/"
      openGraph={{
        type: "website",
        locale: "en_US",
        url: "https://estimation.annetatargalt.ee/",
        title: "Estimation Game",
        description:
          "Quantified Intuitions helps you practice assigning credences to outcomes with a quick feedback loop.",
        site_name: "Estimation Game",
        images: [
          {
            url: "https://www.quantifiedintuitions.org/athena.png",
            width: 800,
            height: 533,
          },
        ],
      }}
      additionalLinkTags={[
        {
          rel: "icon",
          href: "https://www.quantifiedintuitions.org/scale.svg",
        },
      ]}
    />
  );
};
