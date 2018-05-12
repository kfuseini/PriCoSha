# Import Flask Library
import datetime
from flask import Flask, render_template, request, session, url_for, redirect
import pymysql.cursors
import time
from flask import Flask, render_template, request, session, url_for, redirect
import pymysql.cursors

# Initialize the app from Flask
app = Flask(__name__)

# Configure MySQL
conn = pymysql.connect(host='localhost',
                       user='root',
                       password='',
                       db='PriCoSha',
                       charset='utf8mb4',
                       cursorclass=pymysql.cursors.DictCursor
                       )


# Define a route to hello function
@app.route('/')
def hello():
    return render_template('index.html')


# Define route for login
@app.route('/login')
def login():
    return render_template('login.html')


# Define route for register
@app.route('/register')
def register():
    return render_template('register.html')


@app.route('/forget_password')
def forget_password():
    return render_template('forget_password.html')


@app.route('/reset_password')
def reset_password():
    return render_template('reset_password.html')


# Authenticates the login
@app.route('/loginAuth', methods=['GET', 'POST'])
def loginAuth():
    # grabs information from the forms
    username = request.form['username']
    password = request.form['password']

    # cursor used to send queries
    cursor = conn.cursor()
    # executes query
    query = 'SELECT * FROM Person WHERE username = %s and password = %s'
    cursor.execute(query, (username, password))
    # stores the results in a variable
    data = cursor.fetchone()
    # use fetchall() if you are expecting more than 1 data row
    cursor.close()
    error = None
    if (data):
        # creates a session for the the user
        # session is a built in
        session['username'] = username
        return redirect(url_for('home'))
    else:
        # returns an error message to the html page
        error = 'Invalid login or password'
        return render_template('login.html', error=error)


# Authenticates the register
@app.route('/registerAuth', methods=['GET', 'POST'])
def registerAuth():
    # grabs information from the forms
    username = request.form['username']
    password = request.form['password']
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    DOB = request.form["DOB"]

    # cursor used to send queries
    cursor = conn.cursor()
    # executes query
    query = 'SELECT * FROM Person WHERE username = %s'
    cursor.execute(query, (username))
    # stores the results in a variable
    data = cursor.fetchone()
    # use fetchall() if you are expecting more than 1 data row
    error = None
    if (data):
        # If the previous query returns data, then user exists
        error = "This user already exists"
        return render_template('register.html', error=error)
    else:
        ins = 'INSERT INTO Person VALUES(%s, %s,%s,%s,%s)'
        cursor.execute(ins, (username, password, first_name, last_name, DOB))
        conn.commit()
        cursor.close()
        return render_template('index.html')


@app.route('/ForgetPassword', methods=['GET', 'POST'])
def ForgetPassword():
    # grabs information from the forms
    username = request.form['username']
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    DOB = request.form["DOB"]

    cursor = conn.cursor()
    query = 'SELECT username,first_name,last_name,DOB FROM Person WHERE username = %s'
    cursor.execute(query, (username))
    data = cursor.fetchone()
    cursor.close()
    error = None
    if (data):
        session['username'] = username
        return redirect(url_for('reset_password'))
    else:
        error = 'Wrong information!'
        return render_template('forget_password.html', error=error)


@app.route('/ResetPassword', methods=['GET', 'POST'])
def ResetPassword():
    username = session['username']
    password = request.form['password']

    cursor = conn.cursor()
    query = 'UPDATE Person SET password = %s WHERE username = %s'
    cursor.execute(query, (password, username))
    data = cursor.fetchone()
    cursor.close()
    return render_template('login.html')


@app.route('/home')
def home():
    username = session['username']
    cursor = conn.cursor();
    name_list = []  # Today is [name]'s birthday
    name = ''

    # Output username's friends in all FriendGroups
    query_friends = 'SELECT username FROM Member WHERE username_creator = %s'
    cursor.execute(query_friends, (username))
    friends = cursor.fetchall()

    # Today: e.g. 1208
    today = int(time.strftime('%m%d'))
    print(today)
    # Birthday Reminder
    for i in friends:
        query_DOB = 'SELECT DOB FROM Person WHERE username = %s'
        cursor.execute(query_DOB, (i['username']))
        DOB = cursor.fetchone()
        birthday = int(DOB['DOB'])
        if (birthday):
            if ((today - birthday) % 10000 == 0):
                name_list.append(i['username'])
                name = name + i['username'] + '  '
    count = len(name_list)

    # View Content From common friend groups
    query_content = 'SELECT timest, username, file_path, content_name, id FROM content NATURAL JOIN member WHERE ((username_creator, group_name) IN'
    query_content += '(SELECT username_creator, group_name FROM member WHERE username=%s)) '
    query_content += 'UNION SELECT timest, username, file_path, content_name, id FROM content WHERE username=%s || public = 1 ORDER BY timest DESC;'
    cursor.execute(query_content, (username, username))
    content = cursor.fetchall()
    cursor.close()
    return render_template('home.html', username=username, count=count, name=name, posts=content)


@app.route('/post', methods=['GET', 'POST'])
def post():
    # grabs information from the forms
    title = request.form['title']
    link = request.form['link']
    status = request.form['status']
    username = session['username']
    date = datetime.datetime.now()
    # cursor used to send queries
    cursor = conn.cursor()
    # executes query
    query = 'INSERT INTO content(username, timest, file_path, content_name, public) VALUES (%s, %s, %s, %s, %s)'
    data = cursor.execute(query, (username, date, link, title, status))
    # stores the results in a variable
    # stores the results in a variable

    conn.commit();
    cursor.close()
    # error = None
    if (data):
        # creates a session for the the user
        # session is a built in
        return redirect(url_for('home'))
    else:
        # returns an error message to the html page
        error = 'Cannot post to content'
        return render_template('home.html', error=error)


@app.route('/logout')
def logout():
    session.pop('username')
    return redirect('/')


@app.route('/view_friend_groups', methods=['GET'])
def view_friend_groups():
    username = session['username']
    cursor = conn.cursor()
    query = 'SELECT friendgroup.group_name, friendgroup.description, friendgroup.username FROM member JOIN friendgroup WHERE member.group_name = friendgroup.group_name AND friendgroup.username = member.username_creator AND member.username = %s'
    cursor.execute(query, (username));
    data = cursor.fetchall();
    conn.commit();
    cursor.close();
    return render_template('my_friend_groups.html', user=username, data=data)

@app.route('/share/<contentid>',  methods = ['GET', 'POST'])
def share(contentid):
    user = session['username']
    cursor = conn.cursor()
    query = 'SELECT DISTINCT group_name, username_creator FROM member WHERE username = %s'
    cursor.execute(query, (user))
    data = cursor.fetchall()
    return render_template('share.html', groups=data, contentid=contentid)

@app.route('/share_content/<contentid>', methods = ['GET', 'POST'])
def share_content(contentid):
    print(request.form)
    user = session['username']
    group_owner = request.form['group_owner'].split('---')
    group_name = group_owner[0]
    creator = group_owner[1]
    cursor = conn.cursor()
    query = 'INSERT INTO share VALUES (%s, %s, %s)'
    cursor.execute(query, (contentid, group_name, creator))
    conn.commit()
    return redirect(url_for('home'))

@app.route('/viewGroup/<group_name>/<username>', methods = ['GET', 'POST'])
def viewGroup(group_name, username):
    cursor = conn.cursor();
    query = 'SELECT timest, content.username, file_path, content_name, content.id FROM content JOIN share ON (share.id = content.id) WHERE group_name = %s AND share.username =%s ORDER BY timest DESC '
    cursor.execute(query,(group_name, username))
    data = cursor.fetchall()
    conn.commit()
    cursor.close()
    return render_template('viewGroup.html', posts =data, group = group_name)


@app.route('/tag/<contentid>', methods=['GET', 'POST'])
def tag(contentid):
    # IMPORTANT: from time import gmtime, strftime

    tagTime = datetime.datetime.now()
    tagger = session['username']
    taggee = request.form['taggee']
    postID = contentid
    status = (tagger == taggee)
    # datetime: YYYY-MM-DD HH:MI:SS
    cursor = conn.cursor()

    # return redirect(url_for('comment', contentid=contentid))


    # ensure user exists
    query = 'SELECT username FROM person WHERE username = %s'
    cursor.execute(query, (taggee))
    data = cursor.fetchall()
    if (len(data) == 0):  # make sure user exists
        return redirect(url_for('comment', contentid=contentid))

    query = 'SELECT * FROM tag WHERE (username_tagger, username_taggee, id) = (%s, %s, %s)'
    cursor.execute(query, (tagger, taggee, postID))
    data = cursor.fetchall()
    if (len(data) > 0):  # make sure user hasnt been tagged by the taggee already
        return redirect(url_for('comment', contentid=contentid))

    # make sure taggee can see post (taggee is in group with post)
    if (not status):  # if tagger can tag self, they can see the post

        # if the content is public
        query = 'SELECT * FROM Content WHERE ID = %s'
        cursor.execute(query, (postID))
        data = cursor.fetchall()
        check = True  # check groups that the content is shared to?

        if (len(data) == 0):  # content not found? shouldnt happen
            return redirect(url_for('comment', contentid=contentid))  # not sure what to do if it does happen

        elif (data[0]['public']):  # Content is public, no further checking
            check = False

        if (check):  # check if user is in group that the content was shared to
            query = 'SELECT * FROM Share WHERE ID = %s AND username IN (SELECT username FROM member WHERE username_creator = %s OR username = %s)'
            cursor.execute(query, (postID, taggee, taggee))
            data = cursor.fetchall()
            if (len(data) == 0):  # if the user cant see the post
                return redirect(url_for('comment', contentid=contentid))  # i dont know how to handle errors

    # finally the tag can be done, proceed
    query = 'INSERT INTO tag VALUES (%s, %s, %s, %s, %s)'
    cursor.execute(query, (int(postID), tagger, taggee, tagTime, int(status)))
    conn.commit()
    return redirect(url_for('comment', contentid=contentid))


@app.route('/view_tags')
def view_tags():
    user = session['username']
    cursor = conn.cursor()

    query = 'SELECT * FROM Tag JOIN content ON Tag.id = content.id WHERE Tag.username_taggee = %s'
    cursor.execute(query, (user))
    data = cursor.fetchall()
    print(data)

    return render_template('view_tags.html', username=user, tags=data)

    # render some template that shows the tags and a link to /approve


@app.route('/approve/<postID>/<tagger>', methods=['GET', 'POST'])
def approve(postID, tagger):
    taggee = session['username']
    cursor = conn.cursor()

    query = 'UPDATE Tag SET status = %s WHERE username_tagger = %s AND username_taggee = %s AND id = %s'
    cursor.execute(query, (True, tagger, taggee, postID))
    conn.commit()
    return redirect(url_for('view_tags'))


@app.route('/search-a-friend', methods=['POST'])
def searchFriend():
    username = session['username']
    friend = request.form['friend']
    if friend:
        cursor = conn.cursor()

        query = 'SELECT first_name, last_name, username FROM Person WHERE username=%s'
        cursor.execute(query, (friend))
        return render_template('search-friend-list.html', data=cursor.fetchall())
    else:
        return redirect('/home')


@app.route('/send-request/<uname>', methods=['POST'])
def sendRequest(uname):
    username = session['username']
    friend_uname = uname
    cursor = conn.cursor()
    query = 'SELECT username_requestee FROM friendrequest WHERE (username_requestee = %s AND username_requester = %s) OR (username_requestee = %s AND username_requester = %s)'
    cursor.execute(query, (username, uname, uname, username))
    data = cursor.fetchone()
    conn.commit()
    cursor.close()
    error = None
    if (data):
        error = 'Friend request already sent'
        return render_template('search-friend-list.html', data="", error =error)
    if username != friend_uname:
        date = datetime.datetime.now()

        cursor = conn.cursor()

        query = 'INSERT INTO FriendRequest VALUES (%s, %s, %s, %s)'
        cursor.execute(query, (username, friend_uname, date, 0))
        conn.commit()

        return render_template('home.html')


@app.route('/delete/<group_name>')
def delete(group_name):
    username = session['username']
    cursor = conn.cursor()
    query = 'DELETE FROM Member WHERE (username = %s AND group_name = %s)'
    cursor.execute(query, (username, group_name))

    data = cursor.fetchall();
    conn.commit()
    return render_template('my_friend_groups.html', user=username, data=data)


@app.route('/comment/<contentid>', methods=['POST', 'GET'])
def comment(contentid):
    cursor = conn.cursor()
    query = 'SELECT timest, username, comment_text FROM comment WHERE id = %s'
    query2 = 'SELECT username_tagger, username_taggee FROM tag WHERE id =%s AND status =1'
    cursor.execute(query, contentid)
    data = cursor.fetchall()
    cursor.execute(query2, contentid)
    data2 = cursor.fetchall()
    conn.commit()
    cursor.close()
    return render_template('comment.html', contentid=contentid, comments=data, tags=data2)


@app.route('/post_comment/<contentid>', methods=['GET', 'POST'])
def post_comment(contentid):
    cursor = conn.cursor()
    username = session['username']
    comment = request.form['postComment']
    time = datetime.datetime.now();
    query = 'INSERT INTO comment(comment_text, id, timest, username) VALUES(%s, %s, %s, %s)'
    data = cursor.execute(query, (comment, contentid, time, username))
    error = None
    if (data):
        return redirect('/comment/' + contentid)
    else:
        # returns an error message to the html page
        error = 'Could not post comment'
        return render_template('comment.html', error=error)


@app.route('/load-requests')
def friend_requests():
    username = session['username']
    cursor = conn.cursor()
    query = 'SELECT username_requester from friendrequest WHERE username_requestee=%s && status =0'
    cursor.execute(query, (username))
    data = cursor.fetchall()
    return render_template('friend-requests.html', requests=data)


@app.route('/respond_to_request/<requester>', methods=['POST'])
def respond_to_request(requester):
    username = session['username']
    status = request.form['status']
    cursor = conn.cursor()
    time = datetime.datetime.now();

    if int(status) == 1:  # accept friend request
        query = 'UPDATE friendrequest SET status = %s WHERE username_requester = %s && username_requestee = %s'
        cursor.execute(query, (status, requester, username));
    elif (int(status) == -1):
        print(status)
        query = 'DELETE FROM friendrequest WHERE username_requester = %s && username_requestee = %s'
        cursor.execute(query, (status, requester, username));
    conn.commit()
    cursor.close()
    return redirect('/load-requests')


@app.route('/createGroup', methods=['GET'])
def createGroup():
    return render_template("makeAGroup.html")


@app.route('/create-group')
def createFriendGroup():
    return render_template('createGroupForm.html')


def getFriends(username):
    cursor = conn.cursor()
    query = 'SELECT username_requester, username_requestee FROM FriendRequest WHERE (username_requestee=%s or username_requester=%s) AND status=1'
    cursor.execute(query, (username, username))
    friends = cursor.fetchall()
    my_friends = []
    for t in friends:
        if t['username_requester'] == username:
            my_friends.append(t['username_requestee'])
        else:
            my_friends.append(t['username_requester'])
    return my_friends


@app.route('/makeGroup', methods=['POST'])
def makeGroup():
    username = session['username']
    group_name = request.form['group_name']
    description = request.form['desc']
    cursor = conn.cursor();

    error_query = 'SELECT group_name FROM friendgroup WHERE group_name = %s AND username =%s'
    cursor.execute(error_query, (group_name, username))
    data = cursor.fetchone()
    error=None
    if(data):
        error='Group already exists'
        return render_template("makeAGroup.html", error=error)

        conn.commit();
        cursor.close();
    else:
        query = 'INSERT INTO friendgroup VALUES(%s, %s, %s)'
        query2 = 'INSERT INTO member VALUES(%s, %s, %s)'#insert into creator into member

        data = cursor.execute(query, (group_name, username, description));
        cursor.execute(query2, (username, group_name, username));

        error = None
        if (data):
            conn.commit()
            my_friends = getFriends(username)
            return render_template('invite-friends.html', group_name=group_name, friends=my_friends)
        else:
            error = "Could not create group."
            return render_template("makeAGroup.html", error=error)


@app.route('/delete_post/<contentid>', methods=['GET', 'POST'])
def delete_post(contentid):
    cursor = conn.cursor()
    query_comment ='DELETE FROM comment WHERE id =%s'
    query_tag = 'DELETE FROM tag WHERE id = %s'
    cursor.execute(query_comment, contentid)
    cursor.execute(query_tag, contentid)
    query_content = 'DELETE FROM content WHERE id =%s'
    data = cursor.execute(query_content, contentid)
    conn.commit()
    cursor.close()
    if (data):
        return redirect(url_for('home'))
    else:
        error = "Could not delete post"
        return render_template('home.html', error=error)



@app.route('/addfriend/<group_name>', methods=['POST'])
def addfriend(group_name):
    username = session['username']
    friends = getFriends(username)
    return render_template('invite-friends.html', group_name=group_name, friends=friends)



@app.route('/view_friends')
def view_friends():
    username = session['username']
    friends = getFriends(username);
    return render_template('friends.html', friends=friends)


@app.route('/invite-friends/<friend_name>/<group_name>')
def inviteFriends(friend_name, group_name):
    username = session['username']
    friends = getFriends(username)
    cursor = conn.cursor()
    query_select = 'SELECT username FROM member WHERE group_name = %s AND %s IN (SELECT username FROM member WHERE group_name =%s)'
    cursor.execute(query_select, (group_name, friend_name, group_name))
    data = cursor.fetchone()
    if(data):
        error = 'User already in group'
        return render_template('invite-friends.html', group_name=group_name, friends=friends, data="", error=error)
    else:
        query = 'INSERT INTO Member VALUES(%s, %s, %s)'
        cursor.execute(query, (friend_name, group_name, username))
        conn.commit()
        return render_template('invite-friends.html', group_name=group_name, friends=friends, data="")


@app.route('/search-friend-to-invite/<group_name>', methods=['POST'])
def searchFriends(group_name):
    username = session['username']
    friends = getFriends(username)
    friend = request.form['friend']

    if friend in friends:
        data = '''
            <table>
            <form action="/invite-friends/''' + friend + '''/''' + group_name + '''"> 
            <tr>
                <td>''' + friend + '''</td>
                <td><input type="submit" value="invite"></td>
            </tr>
            </form>
            </table>'''
        return render_template('invite-friends.html', group_name=group_name, friends=friends, data=data)
    else:
        data = '''
            <p>No such friend, Search Again or Scroll through the List below</p>'''
        return render_template('invite-friends.html', group_name=group_name, friends=friends, data=data)



@app.route('/defriend/<friend>', methods=['GET', 'POST'])
def defriend(friend):
    cursor = conn.cursor()
    username = session['username']
    friends = getFriends(username)
    friends.remove(friend)
    query = 'DELETE FROM friendrequest WHERE (username_requester = %s AND username_requestee=%s ) OR (username_requester = %s AND username_requestee=%s )'
    query_groupname='SELECT group_name FROM member As t WHERE username=%s AND (%s IN (SELECT username FROM member WHERE group_name=t.group_name))'#find groups they have in common
    cursor.execute(query_groupname, (username, friend))
    groups = cursor.fetchall()
    for group in groups:
        query_remove = 'DELETE FROM member WHERE group_name = %s AND username= %s'#delete from groups they have in common
        cursor.execute(query_remove, (group['group_name'], friend))
    data = cursor.execute(query, (username, friend, friend, username))
    error = None
    if(data):
        return redirect('/view_friends')
    else:
        error="Unable to delete friend"
        return render_template("friends.html",error=error)
    conn.commit()
    cursor.close()


app.secret_key = 'some key that you will never guess'
# Run the app on localhost port 5000
# debug = True -> you don't have to restart flask
# for changes to go through, TURN OFF FOR PRODUCTION
if __name__ == "__main__":
    app.run('127.0.0.1', port=5000, debug=True)