class Solution(object):
    def judgeCircle(self, moves):
        """
        :type moves: str
        :rtype: bool
        """
        from collections import defaultdict
        move_static = defaultdict(int)
        for move in moves:
            move_static[move] += 1
        return (move_static['R'] ==  move_static['L']) & (move_static['U'] == move_static['D'])


if __name__ == '__main__':
    a = "UDUD"
    solution = Solution()
    print(solution.judgeCircle(a))
