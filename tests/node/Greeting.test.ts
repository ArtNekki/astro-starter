import { experimental_AstroContainer as AstroContainer } from "astro/container";
import Greeting from "@/components/Greeting.astro";

test("Greeting renders with correct name", async () => {
  const container = await AstroContainer.create();
  const result = await container.renderToString(Greeting, {
    props: { name: "Мир" },
  });

  expect(result).toContain("Привет, Мир!");
});
