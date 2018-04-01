export const br = (target) => {
  let element = document.createElement('br');
  return target.appendChild(element);
};

export const b = (target, value) => {
  let element = document.createElement('b');
  element.innerHTML = value;
  return target.appendChild(element);
};

export const text = (target, value) => {
  let element = document.createTextNode(value);
  return target.appendChild(element);
};
