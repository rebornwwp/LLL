// string interpolation
let lyrics = 'Never gonnal give you up'
let html = `<div>${lyrics}</div>`
// Note that any placeholder inside the interpolation (${ and }) is treated as a JavaScript expression 
console.log(html)

console.log(`${1 + 1}`)

// multiline strings
let ly = `Never gonna give you
up`
console.log(ly)

// tagged templates
// a sample tag function
function htmlEscape(literals: TemplateStringsArray, ...placeholders: string[]) {
  console.log(literals)
  console.log(placeholders)
  let result = "";

  // interleave the literals with the placeholders
  for (let i = 0; i < placeholders.length; i++) {
    result += literals[i];
    result += placeholders[i]
      .replace(/&/g, '&amp;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;');
  }

  // add the last literal
  result += literals[literals.length - 1];
  return result;
}

let say = "a bird in hand > two in the bush";
let html1 = htmlEscape`<div> I would just like to say : ${say}</div>`;
console.log(html1)