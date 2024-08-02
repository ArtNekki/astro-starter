import { render, screen } from "@testing-library/react";
import Info from "@/components/Info";

const TEST_CONFIGS = [
  { name: "Version", value: "1.0.0" },
  { name: "Environment", value: "Development" },
  { name: "API Endpoint", value: "https://api.example.com" },
];

describe("Info Component", () => {
  it("renders config list correctly", () => {
    render(<Info configList={TEST_CONFIGS} />);

    const listItems = screen.getAllByRole("listitem");

    expect(listItems).toHaveLength(TEST_CONFIGS.length);

    TEST_CONFIGS.forEach((item, index) => {
      const listItem = listItems[index];

      // Проверяем, что элемент списка содержит и имя, и значение конфигурации
      expect(listItem).toHaveTextContent(`${item.name}:`);
      expect(listItem).toHaveTextContent(item.value);

      // Проверяем, что имя находится внутри span
      const nameSpan = listItem.querySelector("span");
      expect(nameSpan).toHaveTextContent(`${item.name}:`);

      // Проверяем порядок: имя должно быть перед значением
      const itemText = listItem.textContent || "";
      expect(itemText.indexOf(item.name)).toBeLessThan(itemText.indexOf(item.value));
    });
  });

  it("renders empty list when no config is provided", () => {
    render(<Info configList={[]} />);
    const list = screen.getByRole("list");
    expect(list).toBeInTheDocument();
    expect(list.children).toHaveLength(0);
  });
});
