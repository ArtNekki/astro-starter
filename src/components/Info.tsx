import React from "react";

const Info = ({ config }) => {
  return (
    <ul className="mb-4">
      {config.map(item => {
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
