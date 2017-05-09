#!/usr/bin/env python
# -*- coding:utf-8 -*-
#
#   Author  :   vito
#   E-mail  :   rebornwwp.gmail.com
#   Date    :   17/05/05 15:43:48
#   Desc    :
#
import random
from faker import Factory

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, String, Integer, Text, ForeignKey, Table
from sqlalchemy.orm import relationship, sessionmaker

engine = create_engine("mysql+pymysql://root:a13880358857@localhost:3306/blog")
Base = declarative_base()


class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    username = Column(String(64), nullable=False, index=True)
    password = Column(String(64), nullable=False)
    email = Column(String(64), nullable=False, index=True)
    articles = relationship('Article')
    userinfo = relationship('UserInfo', backref='user', uselist=False)

    def __repr__(self):
        return "%s(%r)" % (self.__class__.__name__, self.username)


class Article(Base):
    __tablename__ = 'article'
    id = Column(Integer, primary_key=True)
    title = Column(String(255), nullable=False, index=True)
    content = Column(Text)
    user_id = Column(Integer, ForeignKey('users.id'))
    auther = relationship('User')

    def __repr__(self):
        return '%s(%r)' % (self.__class__.__name__, self.title)


def UserInfo(Base):
    __tablename__ = 'userinfos'
    id = Column(Integer, primary_key=True)
    name = Column(String(64))
    qq = Column(String(11))
    phone = Column(String(11))
    link = Column(String(64))
    user_id = Column(Integer, ForeignKey('user.id'))

article_tag = Table(
    'article_tag', Base.metadata,
    Column('article_id', Integer, ForeignKey('article.id')),
    Column('tag_id', Integer, ForeignKey('tags.id'))
    )


class Tag(Base):
    __tablename__ = 'tags'
    id = Column(Integer, primary_key=True)
    name = Column(String(64), nullable=False, index=True)

    def __repr__(self):
        return "%s(%r)" % (self.__class__.__name__, self.name)


class Category(Base):
    __tablename__ = 'categories'
    id = Column(Integer, primary_key=True)
    name = Column(String(64), nullable=False, index=True)
    article = relationship('Article', backref='category')

    def __repr__(self):
        return "%s(%r)" % (self.__class__.__name__, self.name)


if __name__ == "__main__":
    Base.metadata.create_all(engine)

    faker = Factory.create()
    Session = sessionmaker(bind=engine)
    session = Session()

    faker_users = [User(
        username=faker.name(),
        password=faker.word(),
        email=faker.email()
        ) for i in range(10)]
    session.add_all(faker_users)

    faker_tags = [Tag(name=faker.word()) for i in range(20)]
    session.add_all(faker_tags)

    faker_categories = [Categories(name=faker.word()) for i in range(5)]
    session.add_all(faker_categories)

    for i in range(100):
        article = Article(
            title=faker.sentence(),
            content=' '.join(faker.sentences(nb=random.randint(10, 20))),
            auther=random.choice(faker_users),
            category=random.choice(faker_categories)
        )
        for tag in random.sample(faker_tags, random.randint(2, 5)):
            article.tags.append(tag)
        session.add(article)

    session.commit()
