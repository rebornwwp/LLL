// 任何声明（比如变量，函数，类，类型别名或接口）都能够通过添加export关键字来导出。
export interface StringValidator {
    isAcceptable(s: string): boolean;
}

export const numberRegexp = /^[0-9]+$/;

export class ZipCodeValidator implements StringValidator {
    isAcceptable(s: string) {
        return s.length === 5 && numberRegexp.test(s);
    }
}

// 导出语句
class ZipCodeValidator1 implements StringValidator {
    isAcceptable(s: string) {
        return s.length === 5 && numberRegexp.test(s);
    }
}
export { ZipCodeValidator1 };
export { ZipCodeValidator as mainValidator };

// 导入
// import {ZipCodeValidator} from "./zip"
// import { ZipCodeValidator as ZCV } from "./ZipCodeValidator";
// let myValidator = new ZCV();
// import * as validator from "./ZipCodeValidator";
// let myValidator = new validator.ZipCodeValidator();



