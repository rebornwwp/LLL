// TypeScript结构化类型系统的基本规则是，如果x要兼容y，那么y至少具有与x相同的属性

interface Named {
    name: string;
}

let items = [1, 2, 3];
items.forEach((item) => console.log(item));