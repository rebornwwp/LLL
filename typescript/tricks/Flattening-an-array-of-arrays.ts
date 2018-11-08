interface Person {
    firstName: string
    lastName: string
}

const nestedArrays: Person[][] = [
    [
        { firstName: "Andrew", lastName: "Smith" },
        { firstName: "Derek", lastName: "Maloney" },
    ],
    [
        { firstName: "Chris", lastName: "Cawlins" },
    ],
    [
        { firstName: "Susan", lastName: "Sarandon" },
    ]
]

const flattenedArray = [].concat(...nestedArrays)

console.log(flattenedArray)

// 上面的不是类型安全的
const safeFlattenedArray = ([] as Person[]).concat(...nestedArrays)

// For flattening arrays of arrays only one level deep!

// flatten array with multiple levels of nesting

const flatten = function (arr, result = []) {
    for (let i = 0, length = arr.length; i < length; i++) {
        const value = arr[i]
        if (Array.isArray(value)) {
            flatten(value, result)
        } else {
            result.push(value)
        }
    }
    return result
}
