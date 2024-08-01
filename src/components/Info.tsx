import React from "react";

interface Config {
  name: string;
  value: string;
}

const Info = ({ configList }: { configList: Config[] }) => {
  return (
    <ul className="mb-4">
      {configList.map(item => {
        return (
          <li key={item.name}>
            <span>{item.name}:</span> {item.value}
          </li>
        );
      })}
    </ul>
  );
};

export default Info;
